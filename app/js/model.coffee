window.getVertices = ->
    lbf = [-1, -1, 1]
    rbf = [1, -1, 1]
    rtf = [1, 1, 1]
    ltf = [-1, 1, 1]
    lbb = [-1, -1, -1]
    rbb = [1, -1, -1]
    rtb = [1, 1, -1]
    ltb = [-1, 1, -1]

    [].concat(
        lbf, rbf, rtf, ltf,
        lbb, ltb, rtb, rbb,
        ltb, ltf, rtf, rtb,
        lbb, rbb, rbf, lbf,
        rbb, rtb, rtf, rbf,
        lbb, lbf, ltf, ltb
    )

window.getVertexIndices = ->
    faces = [ 0, 1, 2, 0, 2, 3 ]

    flatMap [0...6], (i) -> faces.map (face) -> 4 * i + face

window.getNormals = ->
    front = [0, 0, 1]
    back = [0, 0, -1]
    top = [0, 1, 0]
    bottom = [0, -1, 0]
    right = [1, 0, 0]
    left = [-1, 0, 0]

    flatMap [front, back, top, bottom, right, left], repeat4times

repeat4times = (face) -> flatMap [0...4], -> face

flatMap = (a, f) ->
    [].concat.apply [], a.map f