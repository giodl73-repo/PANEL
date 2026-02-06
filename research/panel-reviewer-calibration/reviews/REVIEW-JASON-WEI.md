# Review: Calibrating AI Reviewer Personas: Domain Expertise Simulation Without Fine-Tuning

**Reviewer**: Jason Wei (OpenAI)
**Expertise**: Chain-of-thought, emergent abilities, prompting strategies
**Round**: 1
**Date**: 2026-02-05

---

## Overall Assessment

This paper investigates whether prompt-constructed LLM personas produce genuinely distinct review outputs. The question is timely and relevant — as LLM-as-judge and multi-agent review systems proliferate, understanding whether persona diversity is real or illusory matters for the field. The paper is well-written and clearly structured.

The prompting methodology is sensible: identity block + key question + venue context + review structure. The finding that key-question injection is the strongest calibration signal resonates with work on chain-of-thought prompting — giving a model a specific reasoning focus changes its output distribution. The 34% increase in inter-reviewer variance from key questions is a compelling headline result.

My main concerns are about the error analysis and the prompting strategy's ceiling. The paper could be significantly strengthened with a more systematic analysis of failure cases and a deeper investigation of what prompting strategies were considered and rejected.

## Score

**Score**: 3/4 — Accept

## Major Issues (Blocking)

### M1: Missing Error Analysis
The paper reports that 89% of personas meet all three calibration quality indicators, but says nothing about the 11% that fail. A systematic error analysis would be highly valuable: Which personas fail? On which papers? Is failure correlated with expertise category, profile specificity, or paper topic? Understanding failure modes is essential for practitioners who want to use this method.

### M2: No Comparison with Alternative Prompting Strategies
The persona prompting approach is presented as the method, but was it compared against alternatives? For instance: (a) chain-of-thought persona reasoning ("First, as an expert in X, I would consider..."), (b) few-shot persona calibration (providing example reviews by the real person), (c) debate-style inter-reviewer prompting. Without comparisons, we don't know if the proposed approach is good or just the first thing that was tried.

## Minor Issues

### m1: Temperature and Sampling Strategy Not Reported
What temperature and sampling parameters were used for review generation? Persona distinctness could be partially attributable to high-temperature sampling rather than persona construction. This is a critical confound that must be reported.

### m2: "Key Question" Specificity Scale Would Be Useful
The paper notes that more specific key questions produce more distinct reviews. Quantifying this on a specificity scale (e.g., generic → domain-specific → paper-specific) with corresponding distinctness metrics would strengthen Section 4.3.

### m3: Prompt Template Not Fully Reproduced
The five-component prompt structure is described but not shown verbatim. Reproducibility requires the exact prompt template.

## Strengths

1. Clean experimental design — the with/without key-question ablation is the right experiment to run
2. Practical and immediately useful — any team running LLM-based reviews can apply these findings
3. The bloc formation result is genuinely interesting and non-obvious

## Questions for Authors

1. What happens if you use chain-of-thought prompting within the persona prompt (e.g., "Think step by step about what [Researcher X] would focus on")?
2. Were any prompting strategies tried and abandoned during development? What didn't work?
3. Does persona order matter? If Reviewer A's review is shown to Reviewer B, does it affect distinctness?

## Recommendations

- Add a systematic error analysis of the 11% failure cases
- Compare at least one alternative prompting strategy (few-shot persona calibration seems most natural)
- Report all generation hyperparameters (temperature, top-p, max tokens)
- Include the full prompt template as an appendix

---

**Verdict**: Accept with Minor Revisions

**Confidence**: High — Prompting strategies and their effects on LLM output are my primary research area.
