#include <iostream>
#include <vector>
using namespace std;

struct Process {
    int pid;
    int arrival;
    int burst;
    int remaining;
    int start;
    int finish;
    int waiting;
    int turnaround;
    bool started;
};

void sjfPreemptive(vector<Process>& proc, int n) {
    int completed = 0, t = 0, prev = -1;
    while (completed < n) {
        int idx = -1, min_rem = 1e9;
        for (int i = 0; i < n; i++) {
            if (proc[i].arrival <= t && proc[i].remaining > 0) {
                if (proc[i].remaining < min_rem) {
                    min_rem = proc[i].remaining;
                    idx = i;
                }
            }
        }
        if (idx != -1) {
            if (!proc[idx].started) {
                proc[idx].start = t;
                proc[idx].started = true;
            }
            proc[idx].remaining--;
            t++;
            if (proc[idx].remaining == 0) {
                proc[idx].finish = t;
                proc[idx].turnaround = proc[idx].finish - proc[idx].arrival;
                proc[idx].waiting = proc[idx].turnaround - proc[idx].burst;
                completed++;
            }
        } else {
            t++;
        }
    }

    for (int i = 0; i < n; i++) {
        cout << "Process " << proc[i].pid << ":\n";
        cout << "  Arrival Time   : " << proc[i].arrival << endl;
        cout << "  Burst Time     : " << proc[i].burst << endl;
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
        proc[i].remaining = proc[i].burst;
        proc[i].started = false;
    }
    sjfPreemptive(proc, n);
    return 0;
}
}
