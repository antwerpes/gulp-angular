module.exports = function (gulp, config, packageJson) {
	require('coffee-script/register');
	require('./index.coffee')(gulp, config, packageJson);
}
