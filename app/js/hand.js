var Hand = React.createClass({
   render: function () {
      return React.DOM.line({
         y2: -this.props.length,
         transform: 'rotate(' + this.props.angle + ')',
         strokeLinecap: 'square',
         strokeWidth: this.props.width,
         stroke: 'darkslategray'
      });
   }
});
