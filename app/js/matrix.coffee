window.transpose = (matrix) ->
    [0...16].map (i) ->
        j = i % 4
        matrix[(i - j) / 4 + 4 * j]

window.makePerspective = (fovy, aspect, znear, zfar) ->
    ymax = znear * Math.tan fovy
    ymin = -ymax
    xmin = ymin * aspect
    xmax = ymax * aspect

    [
        2 * znear / (xmax - xmin), 0, 0, 0
        0, 2 * znear / (ymax - ymin), 0, 0
        (xmax + xmin) / (xmax - xmin)
        (ymax + ymin) / (ymax - ymin)
        (znear + zfar) / (znear - zfar)
        -1
        0, 0, 2 * zfar * znear / (znear - zfar), 0
    ]

window.mvRotate = (angle) ->
    translation = [
        1, 0, 0, 0
        0, 1, 0, 0
        0, 0, 1, 0
        0, 0, -6, 1
    ]

    multMatrix translation, rotation angle

window.invert = (matrix) ->
    getColumn = (n) -> n % 4
    getRow = (n) -> (n - getColumn(n)) / 4
    getIndices = (n) -> [0...16].filter (i) -> return getColumn(i) isnt getColumn(n) && getRow(i) isnt getRow(n)
    getSign = (n) -> if getRow(n) % 2 is getColumn(n) % 2 then 1 else -1

    cofactors = (src, i) ->
        cofactor = (j) -> src[i[j[0]]] * src[i[j[1]]] * src[i[j[2]]]
        cofactor([0, 4, 8]) + cofactor([1, 5, 6]) + cofactor([2, 3, 7]) -
        cofactor([0, 5, 7]) - cofactor([1, 3, 8]) - cofactor([2, 4, 6])

    src = transpose matrix
    dst = [0...16].map (n) -> getSign(n) * cofactors src, getIndices n
    determinant = [0...4].map((i) -> src[i] * dst[i]).reduce sum
    dst.map (x) -> x / determinant

multMatrix = (left, right) ->
    get = (target, i, j) -> target[i + 4 * j]
    getSum = (left, i, right, j) -> [0...4].map((n) -> get(left, i, n) * get(right, n, j)).reduce sum
    [0...16].map (i) -> getSum left, i % 4, right, (i - i % 4) / 4

rotation = (angle) ->
    dotProduct = (vector) -> vector.map((i) -> i * i).reduce sum
    axis = [0.5, 0.6, 0.7]
    mod = Math.sqrt(dotProduct(axis))
    e0 = axis[0] / mod
    e1 = axis[1] / mod
    e2 = axis[2] / mod
    sn = Math.sin(angle)
    cs = Math.cos(angle)
    tn = 1 - cs

    pcs = (e) -> tn * e * e + cs
    s = (e0, e1, e2) -> tn * e0 * e1 + sn * e2

    [
        pcs(e0), s(e0, e1, e2), s(e0, e2, -e1), 0
        s(e0, e1, -e2), pcs(e1), s(e1, e2, e0), 0
        s(e0, e2, e1), s(e1, e2, -e0), pcs(e2), 0
        0, 0, 0, 1
    ]

sum = (a, b) ->
    a + b
