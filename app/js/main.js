var Hand = React.createClass({
   render: function () {
      return React.DOM.line({
         x1: 0,
         y1: 0,
         x2: this.props.length * Math.sin(this.props.angle),
         y2: this.props.length * -Math.cos(this.props.angle),
         strokeLinecap: "square",
         strokeWidth: this.props.width,
         stroke: "darkslategray"
      });
   }
});

var Clock = React.createClass({
   getAngle: function (cycleTime) {
      return 2 * Math.PI * (this.getMillis() % cycleTime) / cycleTime;
   },

   getMillis: function () {
      return this.props.millis - this.props.timezoneOffset * 60000;
   },

   render: function () {
      return React.DOM.svg({
            viewBox: "-1.5 -1.5 3 3"
         },
         React.DOM.circle({
            cx: 0,
            cy: 0,
            r: 1,
            fill: "ivory"}),
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

var ReactRoot = React.createClass({
   getInitialState: function () {
      return {
         millis: Date.now(),
         timezoneOffset: new Date().getTimezoneOffset(),
         request: 0
      };
   },

   componentDidMount: function () {
      this.setState({
         request: requestAnimationFrame(this.tick)
      });
   },

   componentWillUnmount: function () {
      this.stop();
   },

   tick: function () {
      this.setState({
         millis: Date.now(),
         request: requestAnimationFrame(this.tick)
      });
   },

   stop: function () {
      cancelAnimationFrame(this.state.request);
      this.setState({ request: 0 });
   },

   gmt: function () {
      this.setState({timezoneOffset: 0});
   },

   local: function () {
      this.setState({timezoneOffset: new Date().getTimezoneOffset()});
   },

   render: function () {
      return React.DOM.div({},
         React.DOM.button({
               onClick: this.tick,
               disabled: this.state.request !== 0
            },
            'start'),
         React.DOM.button({
               onClick: this.stop,
               disabled: this.state.request === 0
            },
            'stop'),
         React.DOM.button({
               onClick: this.gmt,
               disabled: this.state.timezoneOffset === 0
            },
            'gmt'),
         React.DOM.button({
               onClick: this.local,
               disabled: this.state.timezoneOffset !== 0
            },
            'local'),
         Clock({
            millis: this.state.millis,
            timezoneOffset: this.state.timezoneOffset
         })
      );
   }
});
