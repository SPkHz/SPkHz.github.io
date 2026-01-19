import numpy as np
import matplotlib.pyplot as plt
import matplotlib.patches as mpatches
from matplotlib.patches import FancyBboxPatch, Rectangle, FancyArrowPatch
import matplotlib.lines as mlines

plt.style.use('seaborn-v0_8-whitegrid')
plt.rcParams['font.family'] = 'DejaVu Sans'
plt.rcParams['font.size'] = 11
plt.rcParams['axes.labelsize'] = 12
plt.rcParams['axes.titlesize'] = 14

t = np.arange(1, 23)  # Time steps 1-22

SW1 = np.array([0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1])
SW2 = np.array([1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1])
SW3 = np.array([0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0])
SW4 = np.array([1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0, 0, 1, 1, 0])

Vin = 1

Vload = np.zeros(len(t))
for i in range(len(t)):
    if SW1[i] == 1 and SW3[i] == 1:
        Vload[i] = +Vin
    elif SW2[i] == 1 and SW4[i] == 1:
        Vload[i] = -Vin
    else:
        Vload[i] = 0

# Plot 1: Combined switch signals and load voltage (main figure)
fig, axes = plt.subplots(5, 1, figsize=(12, 10), sharex=True)
fig.suptitle(r'Switch Signals and $V_{\mathrm{Load}}$ Voltage', fontsize=16, fontweight='bold')

switch_data = [SW1, SW2, SW3, SW4]
switch_labels = ['SW1', 'SW2', 'SW3', 'SW4']
colors = ['#2196F3', '#4CAF50', '#FF9800', '#9C27B0']

for idx, (ax, data, label, color) in enumerate(zip(axes[:4], switch_data, switch_labels, colors)):
    ax.step(t, data, where='mid', linewidth=2, color=color)
    ax.fill_between(t, data, step='mid', alpha=0.3, color=color)
    ax.set_xlim([1, 22])
    ax.set_ylim([-0.1, 1.2])
    ax.set_ylabel(label, fontweight='bold')
    ax.set_yticks([0, 1])
    ax.set_yticklabels(['OFF', 'ON'])
    ax.grid(True, alpha=0.3)

# Vload subplot
ax_vload = axes[4]
ax_vload.step(t, Vload, where='mid', linewidth=2.5, color='#E91E63')
ax_vload.fill_between(t, Vload, step='mid', alpha=0.3, color='#E91E63')
ax_vload.set_xlim([1, 22])
ax_vload.set_ylim([-1.3, 1.3])
ax_vload.set_ylabel(r'$V_{\mathrm{load}}$ (V)', fontweight='bold')
ax_vload.set_xlabel('Time Step', fontweight='bold')
ax_vload.set_yticks([-1, -0.5, 0, 0.5, 1])
ax_vload.set_yticklabels([r'$-V_{in}$', r'$-V_{in}/2$', '0', r'$+V_{in}/2$', r'$+V_{in}$'])
ax_vload.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('/home/claude/ee336_assignment14/assets/switch_signals_and_vload.png', dpi=150, bbox_inches='tight')
plt.close()

# Plot 2: Individual switch signals (separate figure for clarity)
fig, axes = plt.subplots(2, 2, figsize=(12, 6))
fig.suptitle('Individual H-Bridge Switch Signals', fontsize=14, fontweight='bold')

for idx, (ax, data, label, color) in enumerate(zip(axes.flat, switch_data, switch_labels, colors)):
    ax.step(t, data, where='mid', linewidth=2, color=color)
    ax.fill_between(t, data, step='mid', alpha=0.3, color=color)
    ax.set_xlim([1, 22])
    ax.set_ylim([-0.1, 1.2])
    ax.set_ylabel(label, fontweight='bold')
    ax.set_xlabel('Time Step')
    ax.set_yticks([0, 1])
    ax.set_yticklabels(['OFF', 'ON'])
    ax.set_title(f'{label} Switching Pattern', fontweight='bold')
    ax.grid(True, alpha=0.3)

plt.tight_layout()
plt.savefig('/home/claude/ee336_assignment14/assets/individual_switch_signals.png', dpi=150, bbox_inches='tight')
plt.close()

# Plot 3: Load voltage only (clean output)
fig, ax = plt.subplots(figsize=(12, 4))

ax.step(t, Vload, where='mid', linewidth=2.5, color='#E91E63')
ax.fill_between(t, Vload, step='mid', alpha=0.3, color='#E91E63')
ax.axhline(y=0, color='black', linestyle='-', linewidth=0.5)
ax.set_xlim([1, 22])
ax.set_ylim([-1.3, 1.3])
ax.set_ylabel(r'$V_{\mathrm{load}}$ (V)', fontweight='bold', fontsize=12)
ax.set_xlabel('Time Step', fontweight='bold', fontsize=12)
ax.set_yticks([-1, 0, 1])
ax.set_yticklabels([r'$-V_{in}$', '0', r'$+V_{in}$'])
ax.set_title(r'H-Bridge Inverter Output: $V_{\mathrm{load}}(t)$', fontsize=14, fontweight='bold')
ax.grid(True, alpha=0.3)

for i, v in enumerate(Vload):
    if v == 1:
        ax.annotate('', xy=(t[i], 1), xytext=(t[i], 0),
                   arrowprops=dict(arrowstyle='->', color='green', lw=1.5))
    elif v == -1:
        ax.annotate('', xy=(t[i], -1), xytext=(t[i], 0),
                   arrowprops=dict(arrowstyle='->', color='red', lw=1.5))

plt.tight_layout()
plt.savefig('/home/claude/ee336_assignment14/assets/vload_output.png', dpi=150, bbox_inches='tight')
plt.close()

# Plot 4: H-Bridge Circuit Diagram
fig, ax = plt.subplots(figsize=(10, 8))
ax.set_xlim(-1, 11)
ax.set_ylim(-1, 9)
ax.set_aspect('equal')
ax.axis('off')
ax.set_title('Single-Phase H-Bridge Inverter Circuit', fontsize=16, fontweight='bold', pad=20)

def draw_voltage_source(ax, x, y, label, size=0.4):
    circle = plt.Circle((x, y), size, fill=False, linewidth=2, color='black')
    ax.add_patch(circle)
    ax.plot([x-0.15, x+0.15], [y+0.1, y+0.1], 'k-', linewidth=2)
    ax.plot([x, x], [y-0.15, y+0.05], 'k-', linewidth=2)
    ax.text(x-0.8, y, label, fontsize=12, ha='right', va='center', fontweight='bold')

def draw_switch(ax, x, y, label, closed=False, horizontal=False):
    if horizontal:
        if closed:
            ax.plot([x, x+1], [y, y], 'b-', linewidth=2)
        else:
            ax.plot([x, x+0.3], [y, y], 'b-', linewidth=2)
            ax.plot([x+0.3, x+0.7], [y, y+0.3], 'b-', linewidth=2)
            ax.plot([x+0.7, x+1], [y, y], 'b-', linewidth=2)
        ax.plot(x, y, 'ko', markersize=6)
        ax.plot(x+1, y, 'ko', markersize=6)
    else:
        if closed:
            ax.plot([x, x], [y, y+1], 'b-', linewidth=2)
        else:
            ax.plot([x, x], [y, y+0.3], 'b-', linewidth=2)
            ax.plot([x, x+0.3], [y+0.3, y+0.7], 'b-', linewidth=2)
            ax.plot([x, x], [y+0.7, y+1], 'b-', linewidth=2)
        ax.plot(x, y, 'ko', markersize=6)
        ax.plot(x, y+1, 'ko', markersize=6)
    ax.text(x+0.5, y+0.5, label, fontsize=11, ha='center', va='center', fontweight='bold',
            bbox=dict(boxstyle='round', facecolor='wheat', alpha=0.8))

draw_voltage_source(ax, 1, 6.5, r'$V_{in}/2$')
draw_voltage_source(ax, 1, 3.5, r'$V_{in}/2$')

ax.plot([1, 1], [6.9, 7.5], 'k-', linewidth=2)
ax.plot([1, 1], [6.1, 5], 'k-', linewidth=2)
ax.plot([1, 1], [3.9, 5], 'k-', linewidth=2)
ax.plot([1, 1], [3.1, 2.5], 'k-', linewidth=2)

ax.plot([1, 3], [7.5, 7.5], 'k-', linewidth=2)
ax.plot([1, 3], [2.5, 2.5], 'k-', linewidth=2)

draw_switch(ax, 3, 6, 'SW1')
draw_switch(ax, 7, 6, 'SW2')
draw_switch(ax, 3, 3, 'SW4')
draw_switch(ax, 7, 3, 'SW3')

ax.plot([3, 3], [7.5, 7], 'k-', linewidth=2)
ax.plot([7, 7], [7.5, 7], 'k-', linewidth=2)
ax.plot([3, 7], [7.5, 7.5], 'k-', linewidth=2)

ax.plot([3, 3], [2.5, 3], 'k-', linewidth=2)
ax.plot([7, 7], [2.5, 3], 'k-', linewidth=2)
ax.plot([3, 7], [2.5, 2.5], 'k-', linewidth=2)

ax.plot([3, 3.5], [5, 5], 'k-', linewidth=2)
ax.plot([6.5, 7], [5, 5], 'k-', linewidth=2)
ax.add_patch(FancyBboxPatch((3.5, 4.5), 3, 1, boxstyle="round,pad=0.05", 
                             facecolor='lightblue', edgecolor='black', linewidth=2))
ax.text(5, 5, 'Load', fontsize=12, ha='center', va='center', fontweight='bold')

ax.annotate('', xy=(4, 5.3), xytext=(3.5, 5.3),
           arrowprops=dict(arrowstyle='->', color='green', lw=2))
ax.text(3.8, 5.6, '+', fontsize=14, fontweight='bold', color='green')
ax.text(6.3, 5.6, '−', fontsize=14, fontweight='bold', color='red')

ax.text(5, 4.0, r'$V_{\mathrm{load}}$', fontsize=12, ha='center', va='center', fontweight='bold')

ax.plot(1, 5, 'ko', markersize=8)
ax.text(0.5, 5, 'N', fontsize=10, ha='center', va='center', fontweight='bold')

ax.text(5, 8.3, 'Top Rail (High Side)', fontsize=10, ha='center', style='italic', color='gray')
ax.text(5, 1.7, 'Bottom Rail (Low Side)', fontsize=10, ha='center', style='italic', color='gray')

plt.tight_layout()
plt.savefig('/home/claude/ee336_assignment14/assets/hbridge_circuit.png', dpi=150, bbox_inches='tight',
            facecolor='white', edgecolor='none')
plt.close()

# Plot 5: Switching Logic Truth Table visualization
fig, ax = plt.subplots(figsize=(10, 5))
ax.axis('off')
ax.set_title('H-Bridge Switching Logic', fontsize=16, fontweight='bold', pad=20)

table_data = [
    ['SW1', 'SW2', 'SW3', 'SW4', r'$V_{\mathrm{load}}$', 'Current Path'],
    ['ON', 'OFF', 'ON', 'OFF', r'$+V_{in}$', 'Top-Left → Load → Bottom-Right'],
    ['OFF', 'ON', 'OFF', 'ON', r'$-V_{in}$', 'Top-Right → Load → Bottom-Left'],
    ['OFF', 'OFF', 'OFF', 'OFF', '0', 'No current flow'],
    ['ON', 'ON', 'OFF', 'OFF', '0', 'Both top switches ON'],
    ['OFF', 'OFF', 'ON', 'ON', '0', 'Both bottom switches ON'],
]

colors_table = [['#E3F2FD'] * 6,
                ['#C8E6C9'] * 6,
                ['#FFCDD2'] * 6,
                ['#FFF9C4'] * 6,
                ['#FFF9C4'] * 6,
                ['#FFF9C4'] * 6]

table = ax.table(cellText=table_data, 
                  cellColours=colors_table,
                  loc='center',
                  cellLoc='center')
table.auto_set_font_size(False)
table.set_fontsize(11)
table.scale(1.2, 2)

for key, cell in table.get_celld().items():
    if key[0] == 0:
        cell.set_text_props(fontweight='bold')
        cell.set_facecolor('#1976D2')
        cell.set_text_props(color='white', fontweight='bold')

plt.tight_layout()
plt.savefig('/home/claude/ee336_assignment14/assets/switching_logic_table.png', dpi=150, bbox_inches='tight',
            facecolor='white')
plt.close()

# Plot 6: Annotated output with switching states
fig, ax = plt.subplots(figsize=(14, 5))

ax.step(t, Vload, where='mid', linewidth=2.5, color='#E91E63', label=r'$V_{\mathrm{load}}$')
ax.fill_between(t, Vload, step='mid', alpha=0.2, color='#E91E63')
ax.axhline(y=0, color='black', linestyle='-', linewidth=0.5)

for i in range(len(t)):
    if Vload[i] == 1:
        color = '#4CAF50'
        label_text = 'SW1,3'
    elif Vload[i] == -1:
        color = '#F44336'  
        label_text = 'SW2,4'
    else:
        color = '#9E9E9E'
        label_text = ''
    
    ax.axvspan(t[i]-0.5, t[i]+0.5, alpha=0.15, color=color)
    if i % 2 == 0 and label_text:
        ax.text(t[i], Vload[i]*0.6, label_text, fontsize=8, ha='center', va='center',
               color=color, fontweight='bold', alpha=0.8)

ax.set_xlim([0.5, 22.5])
ax.set_ylim([-1.4, 1.4])
ax.set_ylabel(r'$V_{\mathrm{load}}$ (V)', fontweight='bold', fontsize=12)
ax.set_xlabel('Time Step', fontweight='bold', fontsize=12)
ax.set_yticks([-1, 0, 1])
ax.set_yticklabels([r'$-V_{in}$', '0', r'$+V_{in}$'])
ax.set_xticks(range(1, 23))
ax.set_title(r'H-Bridge Output Voltage with Active Switch Pairs Indicated', fontsize=14, fontweight='bold')
ax.grid(True, alpha=0.3)

from matplotlib.patches import Patch
legend_elements = [Patch(facecolor='#4CAF50', alpha=0.4, label='SW1 & SW3 ON → +Vᵢₙ'),
                   Patch(facecolor='#F44336', alpha=0.4, label='SW2 & SW4 ON → −Vᵢₙ'),
                   Patch(facecolor='#9E9E9E', alpha=0.4, label='Other combinations → 0V')]
ax.legend(handles=legend_elements, loc='upper right', fontsize=10)

plt.tight_layout()
plt.savefig('/home/claude/ee336_assignment14/assets/vload_annotated.png', dpi=150, bbox_inches='tight')
plt.close()

print("All plots generated successfully!")
print("Files created in /home/claude/ee336_assignment14/assets/")
