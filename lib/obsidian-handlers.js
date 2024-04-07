/**
 * File for handling obsidian notes.
 * 
 * In other words, if we're dealing with ONLY note text, we do it here. Once we get into 
 * our more complex objects, uses of Astro funcs, etc, we go elsewhere.
 */

/**
 * Splits a note into its front matter and note content
 * 
 * @param {string} noteContent
 * 
 * @returns {object}
 */
export function splitFrontMatter( noteContent ) {
    // if we don't have frontmatter, add a dummy object
    if (noteContent.indexOf("---") !== 0) {
        return {
            'frontMatter': {},
            'noteContent': noteContent
        };
    }

    const frontMatterSplitText = noteContent.split("---");
    // remove the empty first index
    frontMatterSplitText.shift();

    return {
        'frontMatter': frontMatterToObject( frontMatterSplitText.shift() ),
        'noteContent': frontMatterSplitText.join('---'),
    }
}


/**
 * Transform a note's yaml frontmatter into a js object
 * 
 * @param {string} frontmatterText  String content of frontmatter
 * @returns {object}            Object form of frontmatter
 */
export function frontMatterToObject(frontmatterText) {
    return frontmatterText.split("\n").reduce((object, line) => {
      const [key, value] = line.split(": ");
      if (key && value) {
        // some yaml strings are quoted
        if (value.trim().indexOf('"') == 0) {
          object[key.trim()] = value.trim().slice(1, -1);
        } else {
          object[key.trim()] = value.trim();
        }
      }
      return object;
    }, {});
  }