import { convertNoteContentToObject } from "./lib/daily-note-handler.js";

const testContent = `
[[periodic/weeklies/2024-W07|Week 7]] 
[[periodic/dailies/2024-02-14|<< Yesterday]] | [[periodic/dailies/2024-02-16|Tomorrow >>]]
# Writing
- [[The Girl]]: pp81 - 96
# Books
- [[Hirohiko Araki - Jojo's - Steel Ball Run|JoJo 7]]: 59 (Gettysburg Dream)
- [[Ursula K Le Guin - Tehanu|Tehanu]]: ch12
- [[JRR Tolkien - The Return Of The King|The Return Of The King]]: 09:24 - book 6 start
- [[Gene Wolfe - Return to the Whorl|Return to the Whorl]]: ch14 (65%), finish

# Other Media
- [[Current 93 - Thunder Perfect Mind]]
- [[Benjamin Walker’s Theory of Everything]]: not all propaganda is art 2
- [[UNHhhh]]: 93
- [[Julien Baker - Sprained Ankle]]
- [[Mirah - The Old Days Feeling]]
- [[Big Blood - The Grove]]
- [[Bob Dylan - The Freewheelin' Bob Dylan]]
- [[ØXN - CYRM]]
# Work
- [[MarComs]] meet
	- [ ] second list
- [[Annual Report]] styles:
	- [x] look at the imports from the old one, see what else we can 'polyfill'
	- [ ] second list
- [[RA Cards]] fixes
	- second list
- [[SearchWP]] fixes
# Cook
# Tasks`;

console.log(convertNoteContentToObject(testContent));