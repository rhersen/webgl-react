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
    return vector.map((i) -> return i * i).reduce(sum);

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