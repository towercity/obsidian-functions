import '../lib/dateExt.js';

import makeReflexNote from './reflex-generic.js';

import config from '../config.js';

// manually doing our weeks now, so as to make it easier; set the week
const firstDay = new Date("Jan 1 2024");
const reflexLength = firstDay.getDaysInMonth(firstDay.getFullYear(), firstDay.getMonth());
const noteTitle = config.monthliesDir + firstDay.getYYYYMM() + '.md';

makeReflexNote(firstDay, reflexLength, noteTitle);
