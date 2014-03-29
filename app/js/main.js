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

function getVertices() {
   var lbf = [-1, -1, 1];
   var rbf = [1, -1, 1];
   var rtf = [1, 1, 1];
   var ltf = [-1, 1, 1];
   var lbb = [-1, -1, -1];
   var rbb = [1, -1, -1];
   var rtb = [1, 1, -1];
   var ltb = [-1, 1, -1];
   var cube = [
      lbf, rbf, rtf, ltf,
      lbb, ltb, rtb, rbb,
      ltb, ltf, rtf, rtb,
      lbb, rbb, rbf, lbf,
      rbb, rtb, rtf, rbf,
      lbb, lbf, ltf, ltb
   ];

   return _.flatten(cube);
}

function getNormals() {
   var front = [0, 0, 1];
   var back = [0, 0, -1];
   var top = [0, 1, 0];
   var bottom = [0, -1, 0];
   var right = [1, 0, 0];
   var left = [-1, 0, 0];
   var cube = [front, back, top, bottom, right, left];

   return _.flatten(_.map(cube, function (item) {
      return _.map(_.range(4), function () {
         return item;
      });
   }));
}

function getVertexIndices() {
   var face = [ 0, 1, 2, 0, 2, 3 ];

   return _.flatten(_.map(_.range(6), function (i) {
      return _.map(face, function (x) {
         return 4 * i + x;
      });
   }));
}

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

function mvRotate(angle) {
   return multMatrix(
      [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, -6, 1],
      rotation(angle)
   );
}

function rotation(angle) {
   var axis = [1, 0, 1];
   var mod = Math.sqrt(dotProduct(axis));
   var e0 = axis[0] / mod;
   var e1 = axis[1] / mod;
   var e2 = axis[2] / mod;
   var sn = Math.sin(angle), cs = Math.cos(angle), tn = 1 - cs;

   function pcs(e) {
      return tn * e * e + cs;
   }

   function s(e0, e1, e2) {
      return tn * e0 * e1 + sn * e2;
   }

   return [
      pcs(e0), s(e0, e1, e2), s(e0, e2, -e1), 0,
      s(e0, e1, -e2), pcs(e1), s(e1, e2, e0), 0,
      s(e0, e2, e1), s(e1, e2, -e0), pcs(e2), 0,
      0, 0, 0, 1
   ];
}

function dotProduct(vector) {
   return _.reduce(_.map(vector, square), sum);

   function square(i) {
      return i * i;
   }
}

function multMatrix(left, right) {
   return _.map(_.range(16), f);

   function f(i) {
      return getSum(left, i % 4, right, (i - i % 4) / 4);
   }

   function getSum(left, i, right, j) {
      function g(n) {
         return get(left, i, n) * get(right, n, j);
      }

      return _.reduce(_.map(_.range(4), g), sum);
   }

   function get(target, i, j) {
      return target[i + 4 * j];
   }
}
