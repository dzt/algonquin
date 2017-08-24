const fs = require('fs');
const cheerio = require('cheerio');

const j = require('request').jar();
const request = require('request').defaults({
    timeout: 10000,
    jar: j
});

const userAgent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36';

var userid = 'xxx';
var password = 'xxx';

console.log(`Logging in with User ID "${userid}"`);

request({
    url: `https://ipassweb.harrisschool.solutions/school/nsboro/syslogin.html`,
    followAllRedirects: true,
    method: 'post',
    headers: {
        'User-Agent': userAgent,
        'Origin': 'https://ipassweb.harrisschool.solutions',
        'Content-Type': 'application/x-www-form-urlencoded',
        'Referer': 'https://ipassweb.harrisschool.solutions/school/nsboro/syslogin.html',
        'Accept-Language': 'en-US,en;q=0.8'
    },
    formData: {
        password: password,
        userid: userid
    }
}, function(err, res, body) {
    if (err) {
        console.log('err', err);
    } else {
        if (body.indexOf('Invalid') > -1) {
            console.log('Error Occured while trying to log you in.');
            return process.exit(1);
        }
        requestsForGrades();
    }
});

function requestsForGrades() {
    request({
        url: `https://ipassweb.harrisschool.solutions/school/nsboro/samgrades.html`,
        followAllRedirects: true,
        method: 'get',
        headers: {
            'User-Agent': userAgent,
            'Accept-Language': 'en-US,en;q=0.8'
        }
    }, function(err, res, body) {
        if (err) {
            console.log('err', err);
        } else {
            parseGrades(body);
        }
    });
}

function parseGrades(html) {

    var tbody = '<table border="1" cellspacing="1" cellpadding="2" bgcolor="#FFFFFF" align="center">' + html.toString().split('<table border="1" cellspacing="1" cellpadding="2" bgcolor="#FFFFFF" align="center">')[1].split('</table>')[0] + '</table>';

    var $ = cheerio.load(html);

    var stdID = removeWhitespace($('.blueHBoldMed').text()).split('ID: ')[1];
    var photo = null

    if ($('#kidphoto').attr('src').indexOf('http') > -1) {
        photo = $('#kidphoto').attr('src');
    }

    var data = {
        id: stdID,
        student: removeWhitespace($('.blueHBoldMed').text()).split('Student:')[1].split(`ID: ${stdID}`)[0].trim(),
        grade: removeWhitespace($('.Datal').eq(1).text()).trim(),
        counselor: removeWhitespace($('.Datal').eq(2).text()).trim(),
        yog: removeWhitespace($('.Datal').eq(3).text()).trim(),
        photo: photo,
        gradesYear: $('#academicYear option').eq(0).text(),
        courses: []
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
            data.courses.push(course);
        };
    });

    console.log(data);
}

function removeWhitespace(text) {
    return text.trim()
};
