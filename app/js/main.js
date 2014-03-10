var Hand = React.createClass({
   render: function () {
      return React.DOM.line({
         x1: 0,
         y1: 0,
         x2: this.props.length * Math.sin(this.props.angle),
         y2: this.props.length * -Math.cos(this.props.angle),
         strokeLinecap: "round",
         strokeWidth: this.props.width,
         stroke: "darkslategray"
      });
   }
});

var ReactRoot = React.createClass({
   getInitialState: function () {
      return {
         millis: Date.now(),
         timezoneOffset: new Date().getTimezoneOffset()
      };
   },

   tick: function () {
      this.setState({
         millis: Date.now()
      });
      this.request = requestAnimationFrame(this.tick);
   },

   componentDidMount: function () {
      this.request = requestAnimationFrame(this.tick);
   },

   componentWillUnmount: function () {
      cancelAnimationFrame(this.request);
   },

   getAngle: function (cycleTime) {
      var millis = this.state.millis - this.state.timezoneOffset * 60000;
      return 2 * Math.PI * (millis % cycleTime) / cycleTime;
   },

   render: function () {
      return React.DOM.svg({
            viewBox: "-1.5 -1.5 3 3"
         },
         React.DOM.circle({
            cx: 0,
            cy: 0,
            r: 1,
            fill: "salmon"}),
         Hand({
            length: 0.7,
            width: 0.1,
            angle: this.getAngle(12 * 60 * 60000)
         }),
         Hand({
            length: 0.9,
            width: 0.05,
            angle: this.getAngle(60 * 60000)
         }),
         Hand({
            length: 0.9,
            width: 0.01,
            angle: this.getAngle(60000)
         })
      );
   }
});
