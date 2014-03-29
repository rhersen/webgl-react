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

   gmt: ->
      @setState timezoneOffset: 0

   local: ->
      @setState timezoneOffset: new Date().getTimezoneOffset()

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
         React.DOM.button(
               onClick: @gmt
               disabled: @state.timezoneOffset is 0
            'gmt'),
         React.DOM.button(
               onClick: @local
               disabled: @state.timezoneOffset isnt 0
            'local')
         Clock
            millis: @state.millis
            timezoneOffset: @state.timezoneOffset
         WebGl
            millis: @state.millis
            timezoneOffset: @state.timezoneOffset
      )