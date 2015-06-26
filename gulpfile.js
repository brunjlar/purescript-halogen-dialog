'use strict'

var gulp        = require('gulp')
  , purescript  = require('gulp-purescript')
  , browserify  = require('gulp-browserify')
  , run         = require('gulp-run')
  , runSequence = require('run-sequence')
  , jsValidate  = require('gulp-jsvalidate')
  ;

var paths = {
    src: [
        'src/**/*.purs',
    ],
    bowerSrc: [
      'bower_components/purescript-*/src/**/*.purs'
    ],
    dest: '',
    docs: [ 
        {
            dest: 'docs/Halogen-Dialog-Signal.md',
            src: 'src/Halogen/Dialog/Signal.purs'
        },
        {
            dest: 'docs/Halogen-Dialog-HTML.md',
            src: 'src/Halogen/Dialog/HTML.purs'
        },
        {
            dest: 'docs/Halogen-Dialog-Utils.md',
            src: 'src/Halogen/Dialog/Utils.purs'
        },
        {
            dest: 'docs/Halogen-Dialog-Input.md',
            src: 'src/Halogen/Dialog/Input.purs'
        },
        {
            dest: 'docs/Halogen-Dialog-YesNo.md',
            src: 'src/Halogen/Dialog/YesNo.purs'
        }        
    ]
};

function compile (compiler, src, opts) {
    var psc = compiler(opts);
    psc.on('error', function(e) {
        console.error(e.message);
        psc.end();
    });
    return gulp.src(src.concat(paths.bowerSrc))
        .pipe(psc)
        .pipe(jsValidate());
};

function docs (target) {
    var docgen = purescript.pscDocs();
    docgen.on('error', function(e) {
        console.error(e.message);
        docgen.end();
    });
    return gulp.src(target.src)
        .pipe(docgen)
        .pipe(gulp.dest(target.dest));
}

gulp.task('make', function() {
    return compile(purescript.pscMake, paths.src, {})
        .pipe(gulp.dest(paths.dest))
});

gulp.task('docs', function() {
    return paths.docs.forEach(function(task) {
        return docs(task);
    });
});

gulp.task('default', function(cb) {
    runSequence('make', 'docs', cb);
});