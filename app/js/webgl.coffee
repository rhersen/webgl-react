window.WebGl = React.createClass
    render: ->
        return React.DOM.canvas({}) unless @program

        @gl.useProgram @program

        @uniform 'p', makePerspective Math.PI / 8, @screenWidth / @screenHeight, 0.1, 10

        m = mvRotate @props.angle
        @uniform 'm', m

        @uniform 'n', transpose invert m

        @gl.bindBuffer @gl.ARRAY_BUFFER, @vertex
        loc = @gl.getAttribLocation @program, 'vertex'
        @gl.vertexAttribPointer loc, 3, @gl.FLOAT, false, 0, 0
        @gl.enableVertexAttribArray loc

        @gl.bindBuffer @gl.ARRAY_BUFFER, @normal
        loc = @gl.getAttribLocation @program, 'normal'
        @gl.vertexAttribPointer loc, 3, @gl.FLOAT, false, 0, 0
        @gl.enableVertexAttribArray loc

        @gl.drawElements @gl.TRIANGLES, @vertexIndices.length, @gl.UNSIGNED_SHORT, 0

        React.DOM.canvas({})

    uniform: (name, array) ->
        @gl.uniformMatrix4fv @gl.getUniformLocation(@program, name), false, array

    componentDidMount: ->
        vertex_shader = "
                        attribute vec3 normal, vertex;
                        varying vec3 l;
                        uniform mat4 n, m, p;
                        void main() {
                            gl_Position = p * m * vec4(vertex, 1);
                            l = vec3(0.6, 0.6, 0.6)+
                            vec3(0.5, 0.5, 0.75) *
                            max(dot((n * vec4(normal, 1.0)).xyz, vec3(0.85, 0.8, 0.75)), 0.0);
                        }
                        "

        fragment_shader = "
                        varying mediump vec3 l;
                        void main() {
                            gl_FragColor = vec4(l, 1.0);
                        }
                        "

        canvas = document.querySelector 'canvas'

        @gl = canvas.getContext 'webgl'

        alert "cannot create webgl context" unless @gl

        @gl.enable @gl.DEPTH_TEST
        @gl.depthFunc @gl.LEQUAL
        @setupBuffers()

        @program = @createProgram vertex_shader, fragment_shader
        @onWindowResize()

        addEventListener 'resize', (=> @onWindowResize()), false

    onWindowResize: ->
        canvas = document.querySelector 'canvas'
        @gl.viewport 0, 0, @screenWidth = canvas.width = innerWidth, @screenHeight = canvas.height = innerHeight

    setupBuffers: ->
        @vertex = @gl.createBuffer()
        @gl.bindBuffer @gl.ARRAY_BUFFER, @vertex
        @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(getVertices()), @gl.STATIC_DRAW
        @normal = @gl.createBuffer()
        @gl.bindBuffer @gl.ARRAY_BUFFER, @normal
        @gl.bufferData @gl.ARRAY_BUFFER, new Float32Array(getNormals()), @gl.STATIC_DRAW
        @vertexIndices = getVertexIndices()
        @gl.bindBuffer @gl.ELEMENT_ARRAY_BUFFER, @gl.createBuffer()
        @gl.bufferData @gl.ELEMENT_ARRAY_BUFFER, new Uint16Array(@vertexIndices), @gl.STATIC_DRAW

    createProgram: (vertex, fragment) ->
        p = @gl.createProgram()

        vs = @createShader vertex, @gl.VERTEX_SHADER
        fs = @createShader fragment, @gl.FRAGMENT_SHADER

        if vs is null or fs is null
            return null

        @gl.attachShader p, vs
        @gl.attachShader p, fs

        @gl.deleteShader vs
        @gl.deleteShader fs

        @gl.linkProgram p

        unless @gl.getProgramParameter p, @gl.LINK_STATUS
            alert "ERROR:\nVALIDATE_STATUS:
                    #{ @gl.getProgramParameter p, @gl.VALIDATE_STATUS }\nERROR:
                    #{ @gl.getError() }\n\n- Vertex Shader -\n#{ @vertex }\n\n- Fragment Shader -\n#{ fragment}"
            return null

        return p

    createShader: (src, type) ->
        shader = @gl.createShader type

        @gl.shaderSource shader, src
        @gl.compileShader shader

        unless @gl.getShaderParameter shader, @gl.COMPILE_STATUS
            alert((if type is @gl.VERTEX_SHADER then "VERTEX" else "FRAGMENT" ) + " SHADER:\n" + @gl.getShaderInfoLog shader)
            return null

        return shader