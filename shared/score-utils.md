# Score Utils — Score Aggregation and Consensus Metrics

Shared utility for computing review scores, trends, and consensus.

## Score Scales

Two scales are used (defined in `config/scoring.yaml`):

### 4-point scale (per-reviewer, per-round)
- 1/4 = Reject
- 2/4 = Weak Accept
- 3/4 = Accept
- 4/4 = Strong Accept

### 10-point scale (cross-portfolio panel)
- 8.0-10.0 = Tier A (Program Flagship)
- 7.0-8.0 = Tier A- (Strong)
- 6.5-7.0 = Tier B+ (Solid)
- 6.0-6.5 = Tier B (Competent)
- 5.0-6.0 = Tier B- (Needs Work)
- 0.0-5.0 = Tier C (Not Ready)

## Aggregation Functions

### average_score(scores)
```
Input:  array of numeric scores
Output: mean score (2 decimal places)
```

### min_score(scores)
```
Input:  array of numeric scores
Output: minimum score
```

### score_distribution(scores)
```
Input:  array of numeric scores
Output: { reject: N, weak_accept: N, accept: N, strong_accept: N }
```

### consensus_level(scores)
```
Input:  array of numeric scores
Output: { level: "strong"|"moderate"|"weak"|"none", std_dev: float }
```

Based on standard deviation thresholds:
- Strong: σ < 0.5
- Moderate: σ < 1.0
- Weak: σ < 1.5
- None: σ >= 1.5

## Threshold Checking

### check_thresholds(scores)
```
Input:  array of reviewer scores
Output: { passed: bool, avg: float, min: float, reasons: string[] }
```

Checks against `config/scoring.yaml` thresholds:
- Average >= 2.5/4
- No individual score < 2/4
- At least 5 reviewers

## Trend Analysis

### score_trend(round_scores)
```
Input:  { round-1: [scores], round-2: [scores], ... }
Output: { trend: "improving"|"stable"|"declining", deltas: [float], projected: float }
```

### verdict_mapping(text_verdict)
```
Input:  string verdict (e.g., "Accept with Minor Revisions")
Output: numeric score on 4-point scale
```

## Bar Rendering

### score_bar(score, max_score, width)
```
Input:  score value, maximum score, bar width in characters
Output: ASCII bar string (e.g., "████████████░░░░")
```

Used by shared/display-utils.md for terminal output.
