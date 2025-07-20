// These are the Rirekisho data structures and functions for organizing and
// creating sections of a resume.
//
// This is mostly meant for internal use, but it may also be useful for creating
// custom resume sections.
//
// Here is a usage example:
// ```typst
// #let show-disco(shape, ..) = { text(fill: gray, shape) }

// #let disco-party = Section(
//   "Disco!",
//   show-disco,
//   "orb",
//   "dodecahedron",
// )
//
// #show-section(disco-party)
// ```
// -----------------------------------------------------------------------------

#import "style.typ"

// A section of the resume.
//
// # Parameters
// - `title`: `any`
//     The title of the section.
// - `show-item`: `function`
//     The function that is used to convert an item into content. It must accept
//     a single positional argument that is an item from `items` and return
//     content or a value that can be directly converted to content.
// - `items`: `any`
//     The items that belong as part of the section. These will be passed to
//     `show-item` when `show-section` is called on the return object of this
//     fucniton.
#let Section(title, show-item, ..items) = {
  return (
    title: title,
    show-item: show-item,
    unnamed-items: items.pos(),
    named-items: items.named(),
  )
}

// Turn a section into content.
//
// # Parameters
// - `section`: `dictionary`
//     The resume section to show, which should be a dictionary formatted like
//     the one returned from `Section`.
//
// # Notes
// - If the section's title is passed as type `str`, the title will be
//    emboldened; otherwise it is left as-is.
// - All other formatting is left up to the `section.show-item` function.
#let show-section(section) = {
  let result = none

  let (title, show-item, unnamed-items, named-items) = section

  // TODO: remove this check---always do the styling
  if type(title) == str {
    title = style.section(title)
  }
  result += title

  let items = named-items.values() + unnamed-items

  result += list(
    ..items.map(item =>
      show-item(item)
    ),
  )

  return block(result)
}
