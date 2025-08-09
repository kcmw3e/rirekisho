// These are the Rirekisho data structures and functions for organizing and
// creating skill sections.
//
// Here is a usage example:
// ```typst
// #let skills = Skills-section(
//   Skillset("No Skills", "Can't Teleport", "Unable to Fly"),
//   Skillset("All Skills", "Super-strength", "Invulnerable", "Omni-immune"),
// )
//
// #show-section(skills)
// ```
// -----------------------------------------------------------------------------

#import "debug.typ": *
#import "section.typ": Section
#import "style.typ"

// Create a set of skills belonging to some category.
//
// # Parameters
// - `category`: `str` | `content`
//     The category that describes the set of skills.
// - `skills`: `str` | `content`
//     The set of skills belonging to the category. As this is an argument sink,
//     named and unnamed arguments will be treated slightly differently; that
//     is, any named argument will be prepended to the list of skills and any
//     unnamed argument will be appended. The named argument *names* will be
//     simply ignored.
#let Skillset(category, ..skills) = {
  return (category: category, skills: skills.named().values() + skills.pos())
}


// Turn a skillset into content.
//
// The skillset will be formatted by the category, followed by a colon, followed
// by a comma-separated list of the skills in the set.
//
// # Parameters
// - `skillset`: `dictionary`
//     The skillset to show; it should be a dictionary formatted like the one
//     returned from `Skillset`.
#let show-skillset(skillset) = {
  let result = none

  let header = style.element(skillset.category +  sym.colon + sym.space)

  let skills = skillset.skills.join(", ")

  result += box(style.header(header))
  result += box(style.body(skills))

  return result
}

// A convenience function to gather a list of skillsets together that can be
// displayed as a section in the resume.
//
// # Parameters
// - `title`: `str` | `content` | `none`
//     The title to display for the skills section.
// - `skillsets`: `arguments`
//     Skillsets should be dictionaries formatted like the ones returned from
//     `Skillset` such that it can be used in `show-skillset`. Arguments may be
//     named or not; in either case they are appended in the order in which they
//     were passed, with the named skillsets first.
#let Skills-section(title: "Skills", ..skillsets) = {
  return Section(title, show-skillset, ..skillsets)
}
