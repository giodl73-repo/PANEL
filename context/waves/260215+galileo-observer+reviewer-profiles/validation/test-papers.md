# Test Paper Selection — A/B Experimental Validation

**Wave**: 260215+galileo-observer+reviewer-profiles (Galileo, observer)
**Phase**: V1 Experimental Setup
**Date**: 2026-02-15

---

## Selection Criteria

1. **Venue diversity**: 5 different venue categories (HCI, ML, Systems, NLP, PL)
2. **Content completeness**: All papers have full sections (3000+ words)
3. **Representative topics**: Mix of systems, theory, and empirical work
4. **Existing papers**: Use actual papers from research/ directory or create synthetic examples

---

## Selected Test Papers

### Paper 1: HCI Evaluation (CHI 2026)

**Directory**: `research/panel-review-methodology` (existing)
**Title**: Panel: AI-Simulated Expert Review for Pre-Submission Quality Improvement
**Venue**: CHI 2026
**Word count**: ~4500 words
**Rationale**: HCI domain, evaluation methodology focus

**Expected reviewers**:
- Ben Shneiderman (HCAI, human agency)
- Michael Bernstein (crowdsourcing, crowd workflows)
- Saleema Amershi (interactive ML, HITL)
- Jeffrey Heer (visualization)
- Ece Kamar (complementarity, human-AI systems)

---

### Paper 2: ML Benchmarking (NeurIPS 2026)

**Directory**: `research/panel-reviewer-profiles` (existing, current wave paper)
**Title**: Token-Efficient Persona Simulation: Persistent Profiles for AI-Simulated Expert Reviews
**Venue**: NeurIPS 2026 (or EMNLP Demo)
**Word count**: ~4000 words
**Rationale**: ML research, evaluation/benchmarking focus

**Expected reviewers**:
- Percy Liang (evaluation, benchmarks, HELM)
- Yejin Choi (commonsense reasoning, evaluation)
- Colin Raffel (scaling, efficiency, T5)
- Song Han (efficiency, pruning, TinyML)
- Chelsea Finn (meta-learning, few-shot)

---

### Paper 3: Distributed Systems (MLSys 2026)

**Directory**: `test/synthetic/distributed-training` (to be created if needed)
**Title**: Adaptive Batch Sizing for Large-Scale Distributed Training
**Venue**: MLSys 2026
**Word count**: ~3500 words (synthetic or use existing systems paper)
**Rationale**: Systems + ML hybrid

**Expected reviewers**:
- Jeff Dean (distributed systems, MapReduce, large-scale ML)
- Song Han (efficiency, TinyML, model compression)
- Matei Zaharia (Spark, distributed computing, Ray)
- Percy Liang (evaluation, systematic benchmarking)
- Trevor Darrell (vision models, training at scale)

---

### Paper 4: Dialogue Generation (ACL 2026)

**Directory**: `test/synthetic/dialogue-model` (to be created if needed)
**Title**: Context-Aware Response Generation for Task-Oriented Dialogue
**Venue**: ACL 2026
**Word count**: ~3800 words (synthetic or use existing NLP paper)
**Rationale**: NLP domain, language generation

**Expected reviewers**:
- Percy Liang (semantic parsing, task-oriented dialogue)
- Yejin Choi (commonsense reasoning, pragmatics)
- Dan Jurafsky (dialogue, conversational AI)
- Chris Manning (NLP, parsing, understanding)
- Diyi Yang (dialogue, social NLP)

---

### Paper 5: Program Synthesis (PLDI 2026)

**Directory**: `test/synthetic/program-synthesis` (to be created if needed)
**Title**: Neural-Guided Enumerative Program Synthesis with Type Constraints
**Venue**: PLDI 2026
**Word count**: ~4200 words (synthetic or use existing PL paper)
**Rationale**: PL/compilers domain

**Expected reviewers**:
- Sumit Gulwani (program synthesis, FlashFill, PROSE)
- Armando Solar-Lezama (sketch-based synthesis, Sketch)
- Isil Dillig (program analysis, synthesis, Houdini)
- Nadia Polikarpova (refinement types, synthesis)
- Xavier Rival (abstract interpretation, static analysis)

---

## Implementation Options

### Option A: Use Existing Papers (Recommended)

Use actual papers from `research/` directory:
- **Paper 1**: panel-review-methodology (CHI, already exists)
- **Paper 2**: panel-reviewer-profiles (NeurIPS/EMNLP, current wave)
- **Paper 3**: panel-portfolio-assessment (use as systems proxy)
- **Paper 4**: panel-synthesis-methods (use as NLP proxy)
- **Paper 5**: Create minimal synthetic PL paper (or use panel-revision-dynamics)

**Pros**: Real content, authentic review simulation
**Cons**: May need to adapt some papers to match venue requirements

### Option B: Create Synthetic Test Papers

Create 5 minimal synthetic papers following conference templates:
- Ensures perfect venue match
- Control over content complexity
- Can test edge cases (very short, very long, etc.)

**Pros**: Perfect experimental control
**Cons**: More setup time, less realistic simulation

---

## Recommendation

**Use Option A** (existing papers) for faster validation. If results show promise, Option B can be used for follow-up experiments with tighter controls.

---

## Next Steps

1. **Verify paper readiness**: Ensure all 5 papers have complete sections
2. **Create paper manifest**: Map paper → venue → expected reviewers
3. **Prepare baseline runs**: Configure panel:review for database mode
4. **Prepare profile runs**: Verify profiles exist for all expected reviewers
5. **Set up instrumentation**: Token logging, cache tracking

---

## Paper Manifest

```yaml
experiments:
  - id: exp1-hci
    paper: panel-review-methodology
    venue: CHI 2026
    baseline_reviewers: [shneiderman, bernstein, amershi, heer, kamar]
    profile_reviewers: [shneiderman, bernstein, amershi, heer, kamar]

  - id: exp2-ml
    paper: panel-reviewer-profiles
    venue: NeurIPS 2026
    baseline_reviewers: [liang, choi, raffel, han, finn]
    profile_reviewers: [liang, choi, raffel, han, finn]

  - id: exp3-systems
    paper: panel-portfolio-assessment
    venue: MLSys 2026
    baseline_reviewers: [dean, han, zaharia, liang, darrell]
    profile_reviewers: [dean, han, zaharia, liang, darrell]

  - id: exp4-nlp
    paper: panel-synthesis-methods
    venue: ACL 2026
    baseline_reviewers: [liang, choi, jurafsky, manning, yang]
    profile_reviewers: [liang, choi, jurafsky, manning, yang]

  - id: exp5-pl
    paper: panel-revision-dynamics
    venue: PLDI 2026
    baseline_reviewers: [gulwani, solar-lezama, dillig, polikarpova, rival]
    profile_reviewers: [gulwani, solar-lezama, dillig, polikarpova, rival]
```

---

## References

- Experimental protocol: `validation/experimental-protocol.md`
- Test fixtures: `test/fixtures/profiles/`
- Research papers: `research/panel-*/`
