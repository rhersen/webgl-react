function sum(a, b) {
   return a + b;
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
