module.exports = function (gulp, packageJson) {
	require('coffee-script/register');
	require('./index.coffee')(gulp, packageJson);
}
