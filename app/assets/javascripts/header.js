
var myScroll;

function loaded() {
  console.log("scrolling");
	myScroll = new IScroll('#wrapper2', {
		mouseWheel: true,
		indicators: [{
			el: document.getElementById('starfield1'),
			resize: false,
			ignoreBoundaries: true,
			speedRatioY: 0.6
		}, {
			el: document.getElementById('starfield2'),
			resize: false,
			ignoreBoundaries: true,
			speedRatioY: 0.3
		}]
	});
}

document.addEventListener('touchmove', function (e) { e.preventDefault(); }, false);
