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
