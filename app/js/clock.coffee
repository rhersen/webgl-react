window.Clock = React.createClass({
   getAngle: (cycleTime) ->
      return 360 * (this.getMillis() % cycleTime) / cycleTime

   getMillis: ->
      return this.props.millis - this.props.timezoneOffset * 60000

   render: ->
      return React.DOM.svg({
            viewBox: '-1.5 -1.5 3 3'
            width: '300'
            height: '300'
         },
         React.DOM.circle(
            r: 1
            fill: 'ivory'),
         Hand(
            length: 0.7
            width: 0.1
            angle: this.getAngle(12 * 60 * 60000)
         ),
         Hand(
            length: 0.9
            width: 0.05
            angle: this.getAngle(60 * 60000)
         ),
         Hand(
            length: 0.9
            width: 0.01
            angle: this.getAngle(60000)
         )
      )
})
