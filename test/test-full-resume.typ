// This is a full-resume "test".
//
// It serves more as an example and easy compilation of a resume to visually
// check things than an actual "pass or fail" kind of test.
// -----------------------------------------------------------------------------

#import "/src/lib.typ": *

#let author = "Person of Many Names"

#let contacts = contact-section(
  phone: phone("+0 (123) 555-0100"),
  email: email("many.names@example.com"),
  linkedin: url-link(name: "LinkedIn", "example", "https://linkedin.com"),
  github: url-link(name: "GitHub", "example", "https://github.com"),
  location: location[Limbo]
)

#let education = education-section(
  masters: education(
    institution: "Magic School",
    location: "Fairyland",
    kind: "W.I.Z.A.R.D.",
    study: "Arcana",
    timeframe: datetime(year: 1, month: 1, day: 1),
    score: [0.9],
    scale: [1.0],
  ),
  backelors: education(
    institution: "Castle",
    location: "Isles of Dust",
    kind: "M.A.G.E.",
    study: "Arcana",
    timeframe: datetime(year: 2, month: 1, day: 1),
    score: [14.1],
    scale: [16.5],
  ),
)

#let works = work-section(
  work(
    company: "Floating Groceries",
    location: "Sparkville, Fairyland",
    position: "Shelf Stocker",
    timeframe: (
      start: datetime(year: 0, month: 7, day: 10),
      end: datetime(year: 0, month: 8, day: 13),
    ),
  )[
    At "Floating Groceries" I worked as a shelf stocker.
    I did not have to interact with a single soul---living or not.
    - Counted what herbs and apparatuses we had in stock
    - Made sure baubles and jewelery were cleaned weekly
  ],
  work(
    company: "Skyward Ink.",
    location: "Floating Lands",
    position: "Herbalist",
    timeframe: (
      start: datetime(year: 2, month: 2, day: 1),
      end: datetime(year: 50, month: 12, day: 18),
    ),
  )[
    - I regularly greeted customers and showed them around the shop, answering
        their questions and providing expertise.
    - Mixed potions and medicines for all ailments, including _Blue~Brain_,
        _Wobbly~Body_, and _The Regular Colds_.
    - Kept a journal of recipes (I was in R&D as well), and actively
        participated in creating new substances for people to test out.
  ],
  work(
    company: "The Royal Mage's Society",
    location: "The World",
    position: "Chief Healer and Artifacts Curator",
    timeframe: (
      start: datetime(year: 50, month: 2, day: 7),
      end: datetime(year: 322, month: 4, day: 23),
    ),
  )[
    I was invited to head the healing center and act as the curator for healing
      artifacts at the Rotal Mage's Society.
    - I directed other healers and made long-term plans for how to grow and
        advance our healing division.
    - As the curator of healing artifacts, I pioneered the incorporation of
        these magical wonders into daily caregiving.
  ],
)

#let projects = project-section(
  project(title: "Automatic Spellmaker", timeframe: "The Year of Spirits")[
    In this project, I created an automatic spell making apparatus, inspired by
      the spirits that arose in The Year of Spirits.
    - The apparatus could make 50 spells every day.
    - It consumed 5 Tubes of mana for every spell created.
  ],
  project(
    title: "Self-writing Paper",
    timeframe: datetime(year: 0038, month: 5, day: 1),
  )[
    - Through experimental efforts, created paper that writes on itself.
    - The paper can write as fast as any being, and without tiring.
    - The paper only requires 1 Tube of mana a day.
  ],
)

#let skills = skills-section(
  skillset("Spells", "Spell Crafting", "Spell Casting"),
  skillset("Wands", "Making Wands", "Analyzing Wands", "Sorting Wands"),
)

#show: resume.with(
  author,
  sections: (contacts, education, works, projects, skills),
)
