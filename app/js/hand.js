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
