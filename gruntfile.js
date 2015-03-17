module.exports = function(grunt) {
  // Do grunt-related things in here
  coffee: {
    compileJoined: {
      options: {
        join: true
      },
      files: {
        'src/script/js/**/main.js': ['src/script/coffee/**/*.coffee'] // concat then compile into single file 
      }
    }
  }
}