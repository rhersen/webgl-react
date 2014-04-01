window.transpose = (matrix) ->
    [0...16].map (i) ->
        j = i % 4
        matrix[(i - j) / 4 + 4 * j]

window.mvRotate = (angle) ->
    multMatrix [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, -6, 1], rotation angle

multMatrix = (left, right) ->
    f = (i) ->
        getSum left, i % 4, right, (i - i % 4) / 4

    getSum = (left, i, right, j) ->
        g = (n) ->
            get(left, i, n) * get(right, n, j)

        [0...4].map(g).reduce sum

    get = (target, i, j) ->
        target[i + 4 * j]

    [0...16].map f

dotProduct = (vector) ->
    vector.map((i) -> i * i).reduce sum

rotation = (angle) ->
    axis = [1, 0, 1]
    mod = Math.sqrt(dotProduct(axis))
    e0 = axis[0] / mod
    e1 = axis[1] / mod
    e2 = axis[2] / mod
    sn = Math.sin(angle)
    cs = Math.cos(angle)
    tn = 1 - cs

    pcs = (e) ->
        tn * e * e + cs

    s = (e0, e1, e2) ->
        tn * e0 * e1 + sn * e2

    [
        pcs(e0), s(e0, e1, e2), s(e0, e2, -e1), 0,
        s(e0, e1, -e2), pcs(e1), s(e1, e2, e0), 0,
        s(e0, e2, e1), s(e1, e2, -e0), pcs(e2), 0,
        0, 0, 0, 1
    ]

invertClosure = () ->
    getColumn = (n) ->
        n % 4

    getRow = (n) ->
        (n - getColumn(n)) / 4

    getSign = (n) ->
        getRow(n) % 2 is getColumn(n) % 2 ? 1 : -1

    getIndices = (n) ->
        hasSameRowOrColumn = (i) ->
            getColumn(i) is getColumn(n) || getRow(i) is getRow(n)

        [0...16].filter (i) -> !hasSameRowOrColumn i

    indices = [0...16].map getIndices
    sign = [0...16].map getSign

    (matrix) ->
        cofactors = (src, i) ->
            cofactor = (j) ->
                src[i[j[0]]] * src[i[j[1]]] * src[i[j[2]]]

            cofactor([0, 4, 8]) + cofactor([1, 5, 6]) + cofactor([2, 3, 7]) - cofactor([0, 5, 7]) - cofactor([1, 3, 8]) - cofactor([2, 4, 6])

        adjoint = (n) ->
            sign[n] * cofactors src, indices[n]

        multSrcDst = (i) ->
            src[i] * dst[i]

        src = transpose matrix
        dst = [0...16].map adjoint
        determinant = [0...4].map(multSrcDst).reduce sum

        dst.map (x) -> x / determinant

window.invert = invertClosure()
