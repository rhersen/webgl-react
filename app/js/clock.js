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
