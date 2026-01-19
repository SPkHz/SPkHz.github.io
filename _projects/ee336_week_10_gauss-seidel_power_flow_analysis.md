---
layout: page
title: EE-336 Gauss-Seidel Power Flow Analysis
description: Iterative power flow solution for a 6-bus system using the Gauss-Seidel method (MATLAB • Y-bus • per-unit system).
img: /assets/img/ee336/assignment-10/convergence_combined.png
importance: 1
category: coursework
related_publications: false
---

This assignment implements the **Gauss-Seidel iterative method** to solve power flow equations for a **6-bus electrical power system**. The analysis determines bus voltage magnitudes and angles that satisfy the network power balance constraints, demonstrating convergence behavior over multiple iterations.

**Author:** Steven Placzek  
**Course:** EE-336 — Electrical Energy Systems  
**Date:** April 1, 2025  
**Tools:** MATLAB (admittance matrix construction, Gauss-Seidel iteration)

---

## Problem Statement

Consider the following 6-bus power system:

<div class="row justify-content-sm-center">
    <div class="col-sm-10 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-10/six_bus_topology.png" title="6-Bus Power System Topology" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    The 6-bus system topology showing the slack bus (Bus 4), load buses, and transmission line connections. Each load bus has identical complex power demand.
</div>

**System Parameters:**

| Parameter | Value |
|:----------|------:|
| Transmission Line Impedance | $$Z_{\text{line}} = 0.009 + j1.0$$ p.u. |
| Load Impedance (all load buses) | $$Z_{L} = 1 + j1$$ p.u. |
| Slack Bus | Bus 4: $$V_4(i) = 1\angle 0°$$ p.u. for all $$i$$ |
| Initial Voltage Guess | $$V_k(0) = 1\angle 0°$$ p.u. for all buses |

The line admittances can be computed as:

$$
Y_{\text{line}} = \frac{1}{Z_{\text{line}}} = \frac{1}{0.009 + j1.0} \approx 9.96\angle{-84.85°} \text{ p.u.}
$$

---

## Gauss-Seidel Method

The Gauss-Seidel power flow method iteratively updates bus voltages using the nodal admittance equation. For load bus $$k$$, the voltage update equation is:

$$
V_k^{(i+1)} = \frac{1}{Y_{kk}} \left[ \frac{P_k - jQ_k}{V_k^{*(i)}} - \sum_{\substack{n=1 \\ n \neq k}}^{N} Y_{kn} V_n^{(i)} \right]
$$

where:
- $$Y_{kk}$$ is the self-admittance (sum of all admittances connected to bus $$k$$)
- $$Y_{kn}$$ is the mutual admittance between buses $$k$$ and $$n$$ (negative of line admittance)
- $$P_k + jQ_k$$ is the specified complex power injection at bus $$k$$

### Y-Bus Matrix Construction

The diagonal elements (self-admittance) are computed as:

$$
Y_{kk} = \sum_{\substack{n=1}}^{N} Y_{kn} \quad \text{(sum of all connected line admittances)}
$$

| Bus | Self-Admittance $$Y_{kk}$$ | $$\|Y_{kk}\|$$ |
|:---:|:---------------------------|---------------:|
| 1 | $$(1.7855 - j19.8393)$$ p.u. | 19.8792 p.u. |
| 2 | $$(1.7855 - j19.8393)$$ p.u. | 19.8792 p.u. |
| 3 | $$(2.6783 - j29.7540)$$ p.u. | **29.8792 p.u.** |
| 4 | $$(1.7855 - j19.8393)$$ p.u. | 19.8792 p.u. |
| 5 | $$(0.8928 - j9.9197)$$ p.u. | 9.9197 p.u. |
| 6 | $$(1.7855 - j19.8393)$$ p.u. | 19.8792 p.u. |

---

## Questions and Solutions

### Part (a): First Iteration Voltage at Bus 3

**Question:** What is the per-unit voltage magnitude and angle for bus 3 at the end of the first iteration?

Using the Gauss-Seidel update equation for Bus 3:

$$
V_3^{(1)} = \frac{1}{Y_{33}} \left[ \frac{P_3 - jQ_3}{V_3^{*(0)}} + V_5^{(0)} Y_{53} + V_6^{(0)} Y_{63} \right]
$$

With initial values $$V_k^{(0)} = 1\angle 0°$$ p.u. for all buses and the load $$S_3 = P_3 + jQ_3 = 1 + j1 = \sqrt{2}\angle 45°$$ p.u.:

$$
\boxed{V_3(1) = 1.0368\angle 1.6766° \text{ p.u.}}
$$

**Magnitude:** $$|V_3(1)| = 1.0368$$ p.u.  
**Angle:** $$\delta_3(1) = 1.6766°$$

---

### Part (b): Slack Bus Voltage After 10 Iterations

**Question:** What is $$V_4(10)$$?

Since Bus 4 is the **slack bus** (reference bus), its voltage is held constant throughout all iterations:

$$
\boxed{V_4(10) = 1.0000\angle 0.0000° \text{ p.u.}}
$$

The slack bus serves two critical functions:
1. Provides the voltage magnitude and angle reference ($$\delta_4 = 0°$$)
2. Supplies the power balance mismatch (losses + generation-load imbalance)

---

### Part (c): Maximum Self-Admittance

**Question:** Which bus has the highest self-admittance value $$|Y_{kk}|$$?

<div class="row justify-content-sm-center">
    <div class="col-sm-10 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-10/self_admittance_comparison.png" title="Self-Admittance Comparison by Bus" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Comparison of self-admittance magnitudes across all buses. Bus 3 has the highest value due to having three connected transmission lines.
</div>

$$
\boxed{\text{Bus 3 has the highest } |Y_{kk}| = 29.8792 \text{ p.u.}}
$$

This makes physical sense: Bus 3 is connected to **three transmission lines** (to buses 5, 6, and indirectly through the network), resulting in a higher self-admittance than buses with fewer connections.

---

## Convergence Analysis

The Gauss-Seidel method converged smoothly over 10 iterations for this system.

<div class="row">
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-10/voltage_magnitude_convergence.png" title="Voltage Magnitude Convergence" class="img-fluid rounded z-depth-1" %}
    </div>
    <div class="col-sm mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-10/voltage_angle_convergence.png" title="Voltage Angle Convergence" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    <b>Left:</b> Voltage magnitude convergence showing all load bus voltages increasing from the flat start (1.0 p.u.) toward their steady-state values. <b>Right:</b> Voltage angle convergence showing phase angles spreading from 0° reference.
</div>

### Key Observations:

1. **Flat Start:** All buses initialized at $$1\angle 0°$$ p.u.
2. **Slack Bus Invariance:** Bus 4 remains fixed at $$1\angle 0°$$ p.u. throughout
3. **Monotonic Convergence:** All voltages increase smoothly without oscillation
4. **Final Values:** After 10 iterations, voltages range from 1.17–1.30 p.u. with angles up to ~14.6°

---

## Iteration Results

<div class="row justify-content-sm-center">
    <div class="col-sm-12 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-10/iteration_table.png" title="Complete Iteration Table" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Complete iteration-by-iteration results showing voltage magnitudes and angles for all six buses. Green cells highlight the answer to part (a): V₃(1). Gold cells highlight the answer to part (b): V₄(10).
</div>

---

## Phasor Representation

<div class="row justify-content-sm-center">
    <div class="col-sm-12 mt-3 mt-md-0">
        {% include figure.liquid loading="eager" path="assets/img/ee336/assignment-10/phasor_diagram.png" title="Voltage Phasor Diagrams" class="img-fluid rounded z-depth-1" %}
    </div>
</div>
<div class="caption">
    Voltage phasor diagrams showing the evolution from iteration 1 to the final solution. Note how the phasors spread out from the reference (slack bus, V₄) as the solution converges.
</div>

---

## Summary of Answers

| Part | Question | Answer |
|:----:|:---------|:-------|
| (a) | $$V_3(1)$$ magnitude and angle | $$\|V_3(1)\| = 1.0368$$ p.u., $$\angle V_3(1) = 1.6766°$$ |
| (b) | $$V_4(10)$$ | $$1.0000\angle 0.0000°$$ p.u. (slack bus, unchanged) |
| (c) | Bus with max $$\|Y_{kk}\|$$ | **Bus 3** with $$\|Y_{33}\| = 29.8792$$ p.u. |

---

## MATLAB Implementation

```matlab
%% EE-336 Week 10: Gauss-Seidel Power Flow
% 6-Bus System Analysis

clear; clc;

%% System Parameters
N = 6;                          % Number of buses
slack_bus = 4;                  % Slack bus index
Z_line = 0.009 + 1j*1.0;        % Transmission line impedance (p.u.)
Y_line = 1/Z_line;              % Line admittance
S_load = 1 + 1j*1;              % Load at each load bus (p.u.)
max_iter = 10;

%% Build Y-bus Matrix
Y = zeros(N, N);
connections = [4,2; 2,1; 4,5; 5,3; 3,6; 6,1];  % Line connections

for k = 1:size(connections, 1)
    i = connections(k, 1);
    j = connections(k, 2);
    Y(i, j) = Y(i, j) - Y_line;
    Y(j, i) = Y(j, i) - Y_line;
    Y(i, i) = Y(i, i) + Y_line;
    Y(j, j) = Y(j, j) + Y_line;
end

%% Gauss-Seidel Iteration
V = ones(N, 1);                 % Flat start: V = 1∠0° for all buses
V_history = zeros(max_iter + 1, N);
V_history(1, :) = V;

for iter = 1:max_iter
    for k = 1:N
        if k == slack_bus
            continue;           % Skip slack bus
        end
        sum_YV = 0;
        for n = 1:N
            if n ~= k
                sum_YV = sum_YV + Y(k, n) * V(n);
            end
        end
        V(k) = (1/Y(k, k)) * (conj(S_load)/conj(V(k)) - sum_YV);
    end
    V_history(iter + 1, :) = V;
end

%% Display Results
fprintf('V3(1) = %.4f∠%.4f° p.u.\n', abs(V_history(2, 3)), angle(V_history(2, 3))*180/pi);
fprintf('V4(10) = %.4f∠%.4f° p.u.\n', abs(V_history(11, 4)), angle(V_history(11, 4))*180/pi);
fprintf('Max |Ykk| at Bus %d = %.4f p.u.\n', find(abs(diag(Y)) == max(abs(diag(Y)))), max(abs(diag(Y))));
```

---

## Notes

- The high voltage magnitudes (>1.0 p.u.) indicate the system is lightly loaded or the load model requires adjustment
- Gauss-Seidel typically converges slower than Newton-Raphson but is simpler to implement
- For larger systems, acceleration techniques (e.g., successive over-relaxation) can improve convergence
