#include <iostream>
#include <vector>
using namespace std;

struct Process {
    int pid;
    int arrival;
    int burst;
    int priority;
    int start;
    int finish;
    int waiting;
    int turnaround;
    bool completed;
};

void priorityNonPreemptive(vector<Process>& proc, int n) {
    int completed = 0, t = 0;
    while (completed < n) {
        int idx = -1, highest = 1e9;
        for (int i = 0; i < n; i++) {
            if (proc[i].arrival <= t && !proc[i].completed) {
                if (proc[i].priority < highest) {
                    highest = proc[i].priority;
                    idx = i;
                }
            }
        }
        if (idx != -1) {
            proc[idx].start = t;
            proc[idx].waiting = t - proc[idx].arrival;
            t += proc[idx].burst;
            proc[idx].finish = t;
            proc[idx].turnaround = proc[idx].finish - proc[idx].arrival;
            proc[idx].completed = true;
            completed++;
        } else {
            t++;
        }
    }

    for (int i = 0; i < n; i++) {
        cout << "Process " << proc[i].pid << ":\n";
        cout << "  Arrival Time   : " << proc[i].arrival << endl;
        cout << "  Burst Time     : " << proc[i].burst << endl;
        cout << "  Priority       : " << proc[i].priority << endl;
        cout << "  Start Time     : " << proc[i].start << endl;
        cout << "  Finish Time    : " << proc[i].finish << endl;
        cout << "  Waiting Time   : " << proc[i].waiting << endl;
        cout << "  Turnaround Time: " << proc[i].turnaround << endl;
        cout << endl;
    }
}

int main() {
    int n;
    cout << "Enter number of processes: ";
    cin >> n;
    vector<Process> proc(n);
    for (int i = 0; i < n; i++) {
        proc[i].pid = i + 1;
        cout << "Process " << proc[i].pid << ":\n";
        cout << "  Enter arrival time: ";
        cin >> proc[i].arrival;
        cout << "  Enter burst time: ";
        cin >> proc[i].burst;
        cout << "  Enter priority (lower number = higher priority): ";
        cin >> proc[i].priority;
        proc[i].completed = false;
    }
    priorityNonPreemptive(proc, n);
    return 0;
}
