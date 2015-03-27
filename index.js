module.exports = function (gulp, config) {
	require('coffee-script/register');
	require('./index.coffee')(gulp, config);
}
