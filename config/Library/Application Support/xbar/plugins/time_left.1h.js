#!/usr/bin/env /opt/homebrew/bin/node
//
//  <xbar.title>Time Left</xbar.title>
//  <xbar.version>v1.0</xbar.version>
//  <xbar.author>Your Name, Another author name</xbar.author>
//  <xbar.author.github>gil</xbar.author.github>
//  <xbar.desc>Shows a progress bar and the percentage of time left for the year/semester/quarter.</xbar.desc>
//  <xbar.dependencies>node</xbar.dependencies>
//
//  Use: /usr/local/bin/npm install moment
//

const moment = require('moment');
const now = moment();

const qStart = moment().startOf('quarter');
const qEnd = moment().endOf('quarter');
const qTotal = moment(qEnd).diff(qStart, 'days');
const qLeft = moment(qEnd).diff(now, 'days');
const qPct = Math.trunc(100 - qLeft / qTotal * 100);

const sStart = moment().month() < 6 ? moment([now.year(), 0, 1]) : moment([now.year(), 6, 1]);
const sEnd = moment().month() < 6 ? moment([now.year(), 5, 1]).endOf('month') : moment().endOf('year');
const sTotal = moment(sEnd).diff(sStart, 'days');
const sLeft = moment(sEnd).diff(now, 'days');
const sPct = Math.trunc(100 - sLeft / sTotal * 100);

const yStart = moment().startOf('year');
const yEnd = moment().endOf('year');
const yTotal = moment(yEnd).diff(yStart, 'days');
const yLeft = moment(yEnd).diff(now, 'days');
const yPct = Math.trunc(100 - yLeft / yTotal * 100);

function progressFor(originalPct, size = 20) {
  const pct = Math.trunc((originalPct - 1) / (100 / size));
  let progress = '';
  for( let i = 0; i < size; i++ ) {
    progress += pct >= i ? '▓' : '░';
  }
  return `[${progress}] ${originalPct}%`;
}

const font = '|font=Courier size=14';

console.log(`⏳${Math.ceil(qLeft/7*10)/10}w`);
console.log('---');
console.log(`Quarter:  ${progressFor(qPct)}${font}`);
console.log(`Semester: ${progressFor(sPct)}${font}`);
console.log(`Year:     ${progressFor(yPct)}${font}`);
