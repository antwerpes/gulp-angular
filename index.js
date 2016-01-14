module.exports = function (gulp, config) {
	require('coffee-script/register');
	return require('./index.coffee')(gulp, config);
}
