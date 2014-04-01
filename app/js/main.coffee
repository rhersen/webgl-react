window.ReactRoot = React.createClass
   getInitialState: ->
      return {
         millis: Date.now(),
         timezoneOffset: new Date().getTimezoneOffset(),
         request: 0
      }

   componentDidMount: ->
      @setState request: requestAnimationFrame @tick

   componentWillUnmount: ->
      @stop()

   tick: ->
      @setState
         millis: Date.now()
         request: requestAnimationFrame @tick

   stop: ->
      cancelAnimationFrame @state.request
      @setState request: 0

   render: ->
      return React.DOM.div({},
         React.DOM.button(
               onClick: @tick
               disabled: @state.request isnt 0
            'start'),
         React.DOM.button(
               onClick: @stop
               disabled: @state.request is 0
            'stop'),
         WebGl
            angle: Math.PI * (@state.millis % 4000) / 2000
      )