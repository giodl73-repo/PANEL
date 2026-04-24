# panel:publication venue

### `venue [targets]`

Venue recommendation for formal publication. Factors in:
- Paper content and contribution type
- Track position (cross-citing papers may target same venue)
- Page limits, deadlines, acceptance rates
- Reviewer profile affinities (which venues their expertise aligns with)

```
panel:publication venue token-efficiency
panel:publication venue --track methodology   # coordinate venue across track
```
