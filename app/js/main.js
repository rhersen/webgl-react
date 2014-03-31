function transpose(matrix) {
   return _.range(16).map(function (i) {
      var j = i % 4;
      return matrix[(i - j) / 4 + 4 * j];
   });
}

function sum(a, b) {
   return a + b;
}

var invert = (function () {
   function getColumn(n) {
      return n % 4;
   }

   function getRow(n) {
      return (n - getColumn(n)) / 4;
   }

   function getSign(n) {
      return getRow(n) % 2 === getColumn(n) % 2 ? 1 : -1;
   }

   function getIndices(n) {
      function hasSameRowOrColumn(i) {
         return getColumn(i) === getColumn(n) || getRow(i) === getRow(n);
      }

      return _.reject(_.range(16), hasSameRowOrColumn);
   }

   var indices = _.map(_.range(16), getIndices);
   var sign = _.map(_.range(16), getSign);

   return function (matrix) {
      var src = transpose(matrix);
      var dst = _.map(_.range(16), adjoint);
      var determinant = _.reduce(_.map(_.range(4), multSrcDst), sum);

      return _.map(dst, function (x) {
         return x / determinant;
      });

      function adjoint(n) {
         return sign[n] * cofactors(src, indices[n]);
      }

      function multSrcDst(i) {
         return src[i] * dst[i];
      }

      function cofactors(src, i) {
         function cofactor(j) {
            return src[i[j[0]]] * src[i[j[1]]] * src[i[j[2]]];
         }

         return cofactor([0, 4, 8]) + cofactor([1, 5, 6]) + cofactor([2, 3, 7]) -
            cofactor([0, 5, 7]) - cofactor([1, 3, 8]) - cofactor([2, 4, 6]);
      }
   };
})();

function makePerspective(fovy, aspect, znear, zfar) {
   var ymax = znear * Math.tan(fovy * Math.PI / 360.0);
   var ymin = -ymax;
   var xmin = ymin * aspect;
   var xmax = ymax * aspect;

   return [
         2 * znear / (xmax - xmin), 0, 0, 0,
      0, 2 * znear / (ymax - ymin), 0, 0,
         (xmax + xmin) / (xmax - xmin),
         (ymax + ymin) / (ymax - ymin),
         (znear + zfar) / (znear - zfar),
      -1,
      0, 0, 2 * zfar * znear / (znear - zfar), 0
   ];
}
