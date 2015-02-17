module.exports = function (gulp) {
	require('coffee-script/register');
	require('./index.coffee')(gulp);
}
