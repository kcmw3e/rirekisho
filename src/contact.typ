// These are the Rirekisho data structures and functions for organizing and
// creating contact information blocks.
//
// Here is a usage example:
// ```typst
// #let phone = (Phone("8675309"))
// #let portfolio = Link(
//   "Portfolio",
//   "example.com/johndoe",
//   "https://example.com",
// )
//
// // Make a custom contact entry.
// #let greeting = Contact(
//   "Howdy",
//   "John",
//   show-value: (who) => { return emph(who) },
// )
//
// #show-contact-section(Contact-section(phone, portfolio, greeting))
// ```
// -----------------------------------------------------------------------------

#import "debug.typ": *
#import "style.typ"

// Create an arbitrary contact entry.
//
// This is meant to be a "base" for creating specific kinds of contacts, such as
// a phone number or email address (which are both provided as part of this
// module).
//
// # Parameters
// - `name`: `str` | `content`
//     The name of the contact, which will be displayed next to the contact.
// - `value`: `any`
//     The value of the contact, which is specific to the kind of contact being
//     created and must be compatible with the `show-value` parameter.
// - `show-value`: `function`
//     A function which takes the `value` and returns `content` to be displayed
//     next to `name`.
#let Contact(name, value, show-value: text) = {
  return (name: name, value: value, show-value: show-value)
}

// Turn a contact entry into content.
#let show-contact(contact) = {
  let (name, value, show-value) = contact

  if show-value != none {
    value = show-value(value)
  }

  name = style.section(name)

  return [#name: #value]
}

// Create a phone number contact entry.
//
// There is no enforcement on the format or type for the number so long as it
// can be appended to a string (for the link). When shown using `show-contact`,
// a `"tel:"` link will be added to the resulting content.
#let Phone(number) = {
  return Contact(
    "Phone",
    number,
    show-value: (number) => {
      link("tel:" + number)
    },
  )
}

// Create an email contact entry.
//
// There is no enforcement on the format or type for the email so long as it can
// be appended to a string (for the link). When using `show-contact`, a
// `"mailto:"` link will be added to the resulting content.
#let Email(email) = {
  return Contact(
    "Email",
    email,
    show-value: (email) => {
      link("mailto:" + email)
    },
  )
}

// Create a generic contact entry with an embedded link.
//
// `name` and `value` are directly passed to `Content` and should follow those
// conventions, and `dest` must be able to be passed to `link` (e.g. a string
// URL).
#let Link(name, value, dest) = {
  return Contact(
    name,
    value,
    show-value: (value) => {
      return link(dest, value)
    },
  )
}

// Create a section of multiple contact entries (created from `Contact` or the
// other common "sub-types" (e.g. `Phone`, `Email`, etc.).
#let Contact-section(..contacts) = {
  return (named-contacts: contacts.named(), unnamed-contacts: contacts.pos())
}

// Turn a section of contacts into content.
//
// The contact entries are simply formatted into a grid with as many columns as
// specified in `columns`. If `columns` is `none`, the number of contact entries
// provided is used instead (i.e. just a single row).
#let show-contact-section(contacts, columns: none) = {
  let contacts = contacts.named-contacts.values() + contacts.unnamed-contacts

  let contact-contents = contacts.map(show-contact)

  columns = if columns == none { contact-contents.len() } else { columns }

  return align(
    center,
    debug-block(
      grid(gutter: 1em, columns: columns, ..contact-contents)
    ),
  )
}
