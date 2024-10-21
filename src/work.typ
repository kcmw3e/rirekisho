// These are the Rirekisho data structures and functions for organizing and
// creating sections of work experiences for a resume.
//
// Here is a usage example:
// ```typst
// #let lemonade-stand = Work-experience(
//   company:  "Lemonade Stand LLC",
//   location: "Sidewalk of 5th St.",
//   position: "Owner",
//   start:    datetime(year: 2042, month: 01, day: 01),
//   end:      datetime(year: 2042, month: 01, day: 02),
// )[
// - I ran a lemonade stand in my front yard for people in my neighborhood.
// ]
//
// #let work = Work-section(lemonade-stand)
//
// #show-work-section(work)
// ```
// -------------------------------------------------------------------------- //

// Define a work experience. 
//
// # Parameters
// - `company`: `str` | `content` | `none`
//     The company where the work was performed.
// - `location`: `str` | `content` | `none`
//     The location where the company is located or where work was done. This
//     can just simply be an abbreviation for a state, province, prefecture,
//     etc., or a full address, or any description of the location.
// - `position`: `str` | `content` | `none`
//     The title of the position.
// - `start`: `str` | `content` | `datetime` | `none`
//     The start date of the work experience.
// - `end`: `str` | `content` | `datetime` | `none`
//     The end date of the work experience. Often, if this is a current position
//     simply `"Present"` will be satisfactory.
// - `body`: `content`
//     The content to provide when showing the experience in the resume. This
//     can simply be a bulleted list of information describing what work was
//     performed, or it may be any content that satisfies describing the work
//     experience.
#let Work-experience(
  company: none,
  location: none,
  position: none,
  start: none,
  end: none,
  body,
  ) = {
  return (
    company: company,
    location: location,
    position: position,
    start: start,
    end: end,
    body: body,
  )
}

// Turn a work experience into content.
//
// The work experience will be formatted as follows:
//   [`position`]{, }[`company`]{ --- }[`location`] ... [`start`]{--}[`end`]
//   [body]
// Where anything in "{}" will be inserted depending on the whether both of the
// fields adjacent to it exist. The exception is that the en-dash between the
// start and end dates will be inserted even if only one of the fields exist.
// Everything left of the "..." will be left-aligned, and everything right of it
// will be right-aligned.
//
// # Parameters
// - `date-format`: `str` | `none`
//     The format string passed to `datetime.display`. If `none`, the format is
//     simply the name of the month followed by the year. This only takes effect
//     when a work experience `start` or `end` field is a `datetime` and gets
//     ignored otherwise.
//
// # Notes
// - Any field in the work experience that is of type `content` will not be
//   modified.
// - The `position` and `company` fields will be italicized if of type `str`.
//   Other fields  of type `str` will be formatted as `text` (which may be
//   modified via `set`/`show` rules.
#let show-work-experience(experience, date-format: none) = {
  if date-format == none {
    date-format = "[month repr:short] [year]"
  }

  let result-content = none

  let (company, location, position, start, end, body) = experience

  // Auto-format position and company fields as italic if they are strings, but
  // leave content alone.
  if type(position) == str {
    position = emph(position)
  }
  if type(company) == str {
    company = emph(company)
  }

  // Format `datetime` fields ahead of time so they can be treated like other 
  // content down the line.
  if type(start) == datetime {
    start = start.display(date-format)
  }
  if type(end) == datetime {
    end = end.display(date-format)
  }

  result-content += position

  if result-content != none and company != none {
    result-content += [, ]
  }
  result-content += company

  if result-content != none and location != none {
    result-content += [ --- ]
  }
  result-content += location

  let dates = none
  dates += start
  if start != none or end != none {
    dates += [--]
  }
  dates += end

  result-content += [#h(1fr)] + dates
  result-content += body

  return result-content
}

// A convenience function to gather a list of work experiences together that can
// be displayed as a section in the resume.
//
// # Parameters
// - `title`: `str` | `content` | `none`
//     The title to display for the work section.
// - `experiences`: `arguments`
//     Experiences should be dictionaries formatted like the ones returned from
//     `Work-experience` such that it can be used in `show-work-experience`.
//     Arguments may be named or not; in either case they are appended in the
//     order in which they were passed, with the named experiences first.
#let Work-section(title: "Work Experience", ..experiences) = {
  return (
    title: title,
    unnamed-experiences: experiences.pos(),
    named-experiences: experiences.named(),
  )
}

// Turn a work section into content.
//
// # Parameters
// - `list-marker`: `str` | `content` | `none`
//     The marker to use for the work experience list. This is directly passed
//     to `list`.
// - `date-format`: `str` | `none`
//     The date format to use for displaying work experiences. See
//     `show-work-experience` for details.
//
// # Notes
// -  If the work section's title is passed as type `str`, the title will be
//    emboldened; otherwise it is left as-is.
// - See notes on `show-work-experience` for how parts of work experiences are
//   formatted depending on types, etc.
#let show-work-section(work, list-marker: none, date-format: none) = {
  let result-content = []

  let (title, unnamed-experiences, named-experiences) = work

  if type(title) == str {
    title = strong(title)
  }
  result-content += title

  let experiences = named-experiences.values() + unnamed-experiences

  result-content += list(
    marker: list-marker,
    ..experiences.map(experience =>
      show-work-experience(experience, date-format: date-format)
    ),
  )
  
  return result-content
}
