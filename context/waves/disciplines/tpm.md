---
format_version: "4.0"
---

# Technical Program Management Patterns

This document defines the program management patterns and best practices for managing waves, phases, and cross-functional delivery in the App Manager system.

---

## Table of Contents

1. [TPM Philosophy](#tpm-philosophy)
2. [Wave Planning Patterns](#wave-planning-patterns)
3. [Timeline & Estimation](#timeline--estimation)
4. [Risk Management](#risk-management)
5. [Dependency Management](#dependency-management)
6. [Resource Planning](#resource-planning)
7. [Communication Patterns](#communication-patterns)
8. [Milestone Tracking](#milestone-tracking)
9. [Cross-Repository Coordination](#cross-repository-coordination)
10. [Process Optimization](#process-optimization)

---

## TPM Philosophy

### Core Principles

1. **Plan for Reality, Not Ideals**: Use actual velocity, not aspirational estimates
2. **Dependencies Are Critical Path**: Identify and manage dependencies before they block
3. **Communicate Early and Often**: Surface risks before they become issues
4. **Measure Progress Objectively**: Track metrics, not feelings
5. **Optimize for Team Flow**: Remove blockers, enable autonomy
6. **Document Decisions**: Future teams will thank you

### TPM Success Metrics

- **On-Time Delivery**: 90%+ of waves complete within estimated timeline
- **Scope Accuracy**: <10% scope creep per wave
- **Risk Mitigation**: 100% of critical risks have mitigation plans
- **Team Velocity**: Stable or improving sprint-over-sprint
- **Blocker Resolution Time**: <24 hours average
- **Documentation Currency**: All decisions documented within 48 hours

---

## Wave Planning Patterns

### Wave Structure

```
Wave
├── Goals (1-3 measurable outcomes)
├── Success Metrics (baseline → target → actual)
├── Phases (4-8 sequential enhancements)
│   ├── Dependencies (what must complete first)
│   ├── Estimated Effort (hours, not story points)
│   └── Testing Strategy
├── Risks & Mitigations
└── Timeline (start date, milestones, end date)
```

### Wave Sizing Guidelines

**Small Wave** (1 week)
- 2-4 phases
- Single repository
- Low complexity
- Few dependencies
- Example: UI polish, bug fixes

**Medium Wave** (2-3 weeks)
- 4-6 phases
- 1-2 repositories
- Medium complexity
- Some dependencies
- Example: New feature, integration

**Large Wave** (4-6 weeks)
- 6-8 phases
- Multiple repositories
- High complexity
- Many dependencies
- Example: Architecture change, portal

**XL Wave** (6+ weeks)
- 8+ phases
- All repositories
- Very high complexity
- Critical path dependencies
- Example: Security overhaul, major refactor

### Phase Breakdown Pattern

Each phase should be:
- **Independently testable**: Can verify completion without later phases
- **Incrementally valuable**: Adds value even if wave stops
- **Right-sized**: 1-2 days of work (8-16 hours)
- **Clearly scoped**: No ambiguity about what's included
- **Dependency-ordered**: Prerequisites come first

**Anti-Patterns**:
- ❌ Phases >3 days (break into smaller phases)
- ❌ Phases that depend on later phases (reorder)
- ❌ Phases with unclear acceptance criteria
- ❌ "Cleanup" or "Polish" phases (integrate into feature phases)

### Example: Well-Structured Wave

```markdown
## Phase 1: Enhancement 01 - Foundation Setup (8 hours)
**Dependencies**: None
**Tasks**:
- [ ] Create directory structure
- [ ] Initialize Vite project
- [ ] Add to pnpm workspace
- [ ] Configure PM2

**Testing**: Portal starts on port 3000
**Success Criteria**: Clean build, PM2 integration working

## Phase 2: Enhancement 02 - Shared Layout (6 hours)
**Dependencies**: Phase 1 complete
**Tasks**:
- [ ] Create PortalHeader component
- [ ] Create TabNavigation component
- [ ] Add responsive design

**Testing**: Components render, responsive works
**Success Criteria**: Layout components exported from @common/ui

## Phase 3: Enhancement 03 - App Integration (12 hours)
**Dependencies**: Phase 2 complete, TCM frontend available
**Tasks**:
- [ ] Export TCM app component
- [ ] Import into Portal
- [ ] Configure routing

**Testing**: TCM renders in portal, navigation works
**Success Criteria**: Seamless tab switching
```

---

## Timeline & Estimation

### Estimation Patterns

**Use Historical Data**:
- Review past enhancements of similar complexity
- Check actual time vs. estimated time
- Identify patterns in over/underestimation

**Estimation Formula**:
```
Estimated Hours = Base Estimate × Complexity Factor × Uncertainty Factor

Complexity Factors:
- Simple (familiar tech, clear requirements): 1.0x
- Medium (some new tech, mostly clear): 1.5x
- Complex (new tech, unclear requirements): 2.0x
- Very Complex (research needed, high uncertainty): 3.0x

Uncertainty Factors:
- Low uncertainty (done this before): 1.0x
- Medium uncertainty (new but similar): 1.3x
- High uncertainty (never done this): 1.5x
- Very high uncertainty (research spike needed): 2.0x
```

**Example**:
- Base estimate: 8 hours (build React component)
- Complexity: 1.5x (integrating with new routing architecture)
- Uncertainty: 1.3x (haven't done embedded app pattern before)
- Final estimate: 8 × 1.5 × 1.3 = **15.6 hours** (round to 16)

### Timeline Patterns

**Wave Timeline**:
```
Week 1: Phases 1-3 (foundation, setup, initial integration)
Week 2: Phases 4-6 (core features, testing, refinement)
Week 3: Phases 7-8 (polish, documentation, deployment)
Buffer: 10-20% for unexpected issues
```

**Milestone Spacing**:
- **Weekly milestones** for waves >2 weeks
- **Mid-wave checkpoint** for all waves
- **Pre-launch review** before final phase
- **Post-launch retrospective** within 3 days

**Buffer Allocation**:
- Small waves: 10% buffer
- Medium waves: 15% buffer
- Large waves: 20% buffer
- XL waves: 25% buffer

---

## Risk Management

### Risk Assessment Matrix

| Probability | Impact Low | Impact Medium | Impact High | Impact Critical |
|------------|-----------|---------------|-------------|----------------|
| **Very Likely (>70%)** | Medium | High | Critical | Critical |
| **Likely (40-70%)** | Low | Medium | High | Critical |
| **Possible (20-40%)** | Low | Low | Medium | High |
| **Unlikely (<20%)** | Low | Low | Low | Medium |

### Risk Categories

**Technical Risks**:
- New technology/framework
- Complex integration
- Performance concerns
- Security vulnerabilities
- Browser/platform compatibility

**Dependency Risks**:
- External team dependencies
- Third-party library availability
- Infrastructure readiness
- Data migration requirements

**Resource Risks**:
- Key person unavailability
- Competing priorities
- Skill gaps
- Tooling availability

**Scope Risks**:
- Unclear requirements
- Changing requirements
- Feature creep
- Underestimated complexity

### Risk Documentation Pattern

```markdown
## Risks & Mitigation

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| PM2 Windows compatibility issues | High | Medium | Test early (Phase 1), have batch script fallback |
| React Router conflicts | Critical | High | Spike solution before Phase 3, validate approach |
| Bundle size too large | Medium | Low | Monitor throughout, implement code splitting |
| Timeline slip due to complexity | Medium | Medium | 20% buffer added, weekly checkpoint reviews |
```

### Mitigation Strategies

**Avoid**: Change plan to eliminate risk
- Example: Use proven tech instead of experimental

**Reduce**: Minimize probability or impact
- Example: Spike solution before committing

**Transfer**: Move risk to another party
- Example: Use vendor-supported library

**Accept**: Acknowledge and monitor
- Example: Document known limitation, plan fix for later

---

## Dependency Management

### Dependency Types

**Sequential Dependencies**:
```
Phase 1 → Phase 2 → Phase 3
```
- Phase 2 can't start until Phase 1 completes
- Critical path calculation essential
- Optimize by parallelizing non-dependent work

**Parallel Dependencies**:
```
       ┌─ Phase 2 ─┐
Phase 1┤           ├→ Phase 4
       └─ Phase 3 ─┘
```
- Phases 2 and 3 can proceed simultaneously
- Phase 4 waits for both
- Maximize parallelization

**External Dependencies**:
- Other teams
- Third-party services
- Infrastructure provisioning
- Review/approval processes

### Dependency Tracking Pattern

```markdown
## Phase 3: Enhancement 03 - App Integration

**Dependencies**:
- ✅ Phase 2 complete (internal)
- ✅ TCM frontend available (external - ready)
- ⏳ React Router v6 spike (internal - in progress)
- ❌ Design system finalized (external - blocked)

**Blocked By**: Design system not ready
**Mitigation**: Use placeholder styles, update in Phase 5
```

### Dependency Management Best Practices

1. **Document All Dependencies**: Don't assume they're obvious
2. **Track External Dependencies**: Set up regular check-ins
3. **Have Contingency Plans**: What if dependency fails?
4. **Front-Load Risk**: Validate critical dependencies early
5. **Communicate Delays**: Surface dependency delays immediately

---

## Resource Planning

### Capacity Planning

**Developer Capacity**:
- Assume 6 productive hours/day (not 8)
- Account for meetings, context switching, interruptions
- Sprint capacity = 6 hours × days - overhead

**Overhead Estimates**:
- Standups/planning: 5% (2 hours/week)
- Code reviews: 10% (4 hours/week)
- Meetings: 15% (6 hours/week)
- Unplanned work: 10% (4 hours/week)
- **Total overhead: 40%**

**Effective Capacity**:
- 40 hours/week × 60% = **24 productive hours/week**
- 2-week sprint = **48 productive hours**

### Work Distribution Pattern

**Balanced Load**:
```
Week 1: 24 hours planned work + 6 hours buffer
Week 2: 24 hours planned work + 6 hours buffer
Total: 48 hours + 12 hours buffer = 60 hours (75% capacity)
```

**Anti-Pattern** (Overload):
```
Week 1: 40 hours planned work
Week 2: 40 hours planned work
Total: 80 hours (133% capacity) ❌ Will slip
```

### Skill Gap Management

**Identify Skills Needed**:
- React Router v6 (new to team)
- Vite library mode (unfamiliar)
- Component export patterns (never done)

**Mitigation**:
- Research spike (4 hours)
- Pair programming (ongoing)
- Documentation review (2 hours)
- Add learning time to estimates

---

## Communication Patterns

### Status Update Cadence

**Daily** (for active waves):
- Quick update in team channel
- Blockers surfaced immediately
- No meetings unless blocker needs discussion

**Weekly** (for all waves):
- Progress vs. plan (phases complete, hours burned)
- Upcoming milestones
- Risks and mitigation status
- Ask for help if needed

**Milestone Reviews**:
- Demo completed functionality
- Review metrics vs. goals
- Adjust plan if needed
- Celebrate wins

### Communication Templates

**Daily Update**:
```
📊 Wave 6 Update - Day 5

✅ Completed: Phase 2 (Shared Layout)
🔄 In Progress: Phase 3 (App Integration)
🎯 On track for Week 1 milestone

🚧 Blockers: None
⚠️ Risks: React Router spike taking longer than estimated
   └─ Mitigation: Added 4 hours to Phase 3 estimate
```

**Weekly Summary**:
```
📈 Wave 6 - Week 1 Summary

Progress:
- Phases Complete: 3/8 (38%)
- Hours Burned: 24/60 (40%)
- Status: On Track ✅

Highlights:
- Portal foundation complete
- Layout components working well
- Responsive design tested on mobile

Next Week:
- Complete app integration (Phases 4-5)
- Begin testing strategy (Phase 6)

Risks:
- Bundle size concern (monitoring)
- Timeline buffer at 12 hours (good)
```

---

## Milestone Tracking

### Milestone Types

**Foundation Complete** (Week 1 for medium waves):
- Infrastructure working
- Basic scaffolding in place
- Ready for feature development

**Feature Complete** (70% through wave):
- All planned features implemented
- Core testing done
- Ready for refinement

**Launch Ready** (95% through wave):
- All testing complete
- Documentation updated
- Deployment tested
- Ready for production

### Milestone Criteria

Each milestone needs:
- **Clear definition**: What "done" means
- **Measurable criteria**: Objective success conditions
- **Demo-able artifact**: Something to show stakeholders
- **Go/No-Go decision**: Continue or adjust plan

**Example Milestone**:
```markdown
## Milestone: Portal Foundation Complete

**Target Date**: End of Week 1
**Criteria**:
- [ ] Portal starts on port 3000
- [ ] Layout components render
- [ ] Responsive design works
- [ ] PM2 integration functional
- [ ] Clean build with no errors

**Demo**: Show portal layout with placeholder content
**Go/No-Go**: If >2 criteria unmet, reassess Phase 3 start
```

---

## Cross-Repository Coordination

### Multi-Repo Wave Pattern

**Affected Repos**:
- appmanager (primary)
- TCM frontend (component export)
- NHL frontend (component export)
- Apportionment frontend (component export)

**Coordination Strategy**:
1. **Sequence Work**: Start with dependencies first
2. **Sync Points**: Weekly sync across repos
3. **Integration Testing**: Test cross-repo integration early
4. **Commit Coordination**: Document commit SHAs for traceability

### Commit Tracking Pattern

```markdown
## Cross-Repo Commits

### appmanager
- E40 (Portal Foundation): abc123d
- E41 (Shared Layout): def456e

### TCM Frontend
- Component Export: ghi789f

### NHL Frontend
- Component Export: jkl012m

**Integration Test**: Commit nop345q (all repos)
```

---

## Process Optimization

### Wave Retrospective Pattern

**After each wave**, conduct retrospective:

**What Went Well**:
- Fast foundation setup (Phase 1 done in 6 hours vs 8)
- Good communication throughout
- Early risk mitigation paid off

**What Didn't Go Well**:
- Phase 3 took 16 hours (estimated 12)
- Routing conflicts discovered late
- Insufficient React Router spike

**Action Items**:
- Add architecture spike phase for new patterns
- Increase complexity factor for integration work
- Front-load technical validation

### Process Metrics

**Track These Metrics**:
- Estimate accuracy (actual vs. estimated hours)
- Scope creep (features added mid-wave)
- Blocker frequency (how often blocked)
- Risk realization (which risks became issues)
- Team velocity (hours completed per week)

**Improve Based On**:
- Patterns in underestimation
- Common blockers
- Frequently realized risks
- Team capacity trends

### Continuous Improvement

**Every 3 Waves**:
- Review estimation accuracy
- Update complexity factors
- Refine phase templates
- Improve risk checklists
- Update documentation

**Annually**:
- Major process review
- TPM patterns update
- Tool evaluation
- Training needs assessment

---

## Common Patterns by Wave Type

### Security Wave
- Longer timeline (security testing takes time)
- External dependency (security review)
- Higher uncertainty (vulnerabilities unpredictable)
- Add 30% buffer minimum

### Infrastructure Wave
- High technical risk
- Significant external dependencies (Docker, PM2, databases)
- Extensive testing required
- Rollback plan mandatory

### UX/Portal Wave
- Design dependency critical
- User testing needed
- Iterative refinement expected
- Design-to-dev handoff checkpoint

### Integration Wave
- Multiple repos affected
- High dependency complexity
- Integration testing essential
- Coordination overhead significant

---

## Best Practices Summary

### Do's ✅
- Document all assumptions
- Track dependencies explicitly
- Communicate risks early
- Update status regularly
- Use historical data for estimates
- Build in buffer time
- Celebrate milestones
- Learn from retrospectives

### Don'ts ❌
- Don't ignore early warning signs
- Don't commit without buffer
- Don't hide risks or issues
- Don't skip retrospectives
- Don't over-optimize estimates (be realistic)
- Don't promise what you can't deliver
- Don't forget cross-repo coordination
- Don't skip milestone reviews

---

## Templates & Checklists

### Wave Kickoff Checklist

- [ ] Goals clearly defined and measurable
- [ ] Success metrics baselined
- [ ] All phases have dependencies documented
- [ ] Estimates include complexity and uncertainty factors
- [ ] Risks identified with mitigation plans
- [ ] Milestones defined with clear criteria
- [ ] Communication plan established
- [ ] Resource capacity validated
- [ ] Cross-repo coordination planned (if applicable)
- [ ] Buffer time allocated

### Weekly Checkpoint Checklist

- [ ] Progress vs. plan reviewed
- [ ] Hours burned vs. estimated tracked
- [ ] Upcoming milestones on track
- [ ] Risks reassessed
- [ ] Blockers identified and mitigated
- [ ] Team capacity sufficient
- [ ] Communication sent to stakeholders

### Wave Completion Checklist

- [ ] All phases complete
- [ ] All success metrics achieved
- [ ] Testing complete
- [ ] Documentation updated
- [ ] Commits tracked (cross-repo if applicable)
- [ ] Retrospective scheduled
- [ ] Lessons learned documented
- [ ] Next wave planned

---

**Last Updated**: 2026-01-28
**Version**: 1.0
**Status**: Active
