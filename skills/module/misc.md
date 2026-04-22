# panel:module — Miscellaneous Subcommands

Small subcommands grouped together: assign, track, member.

---

## `assign <paper> <track>`

Assign a paper to a track and update MODULE.md.

```
panel:module assign panel-profile-caching methodology
```

Validates chain position, warns if paper breaks causal order.

---

## `track <name>`

Add a new track or inspect an existing one.

```
panel:module track                    # list all tracks
panel:module track methodology        # inspect track details
panel:module track new-track-name    # add new track (interactive)
```

---

## `member <name>`

Regenerate one panel member's assessment, reload their profile,
rebuild OLE context, re-run synthesis. No new round.

```
panel:module member "Percy Liang"
```
