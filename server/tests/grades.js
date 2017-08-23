var fs = require('fs');
var cheerio = require('cheerio');

fs.readFile('grades.html', function(err, html) {

    if (err) {
      console.log('Could not find any files matching grades.html');
      return process.exit(1);
    }


    var tbody = '<table border="1" cellspacing="1" cellpadding="2" bgcolor="#FFFFFF" align="center">' + html.toString().split('<table border="1" cellspacing="1" cellpadding="2" bgcolor="#FFFFFF" align="center">')[1].split('</table>')[0] + '</table>';

    var $ = cheerio.load(html);

    console.log('Loaded grades.html file');

    var stdID = removeWhitespace($('.blueHBoldMed').text()).split('ID: ')[1];

    var data = {
      id: stdID,
      student: removeWhitespace($('.blueHBoldMed').text()).split('Student:')[1].split(`ID: ${stdID}`)[0].trim(),
      grade: '',
      counselor: '',
      yog: '',
      photo: '',
      grades: {
        year: '',
        results: []
      }
    };

    cheerio.load(tbody)('tr').each(function(i, element) {

      var teacher = removeWhitespace(cheerio.load(tbody)(this).find('td').eq(1).html()).split('<br>')[1];

      var course = {
        id: removeWhitespace(cheerio.load(tbody)(this).find('td').eq(0).text()),
        name: removeWhitespace(cheerio.load(tbody)(this).find('td').eq(1).html()).split('<br>')[0].split('\n')[0],
        credits: removeWhitespace(cheerio.load(tbody)(this).find('td').eq(2).text()),
        comments: removeWhitespace(cheerio.load(tbody)(this).find('td').eq(3).text()),
        teacher: teacher
      };
      if (course.id != 'Course') {
        data.grades.results.push(course);
      };
    });

    console.log(data);

});

function removeWhitespace(text) {
  return text.trim()
};
