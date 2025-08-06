#include <iostream>
#include <vector>
#include <queue>
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

void roundRobin(vector<Process>& proc, int n, int quantum) {
    queue<int> q;
    int t = 0, completed = 0;
    vector<bool> inQueue(n, false);

    while (completed < n) {
        for (int i = 0; i < n; i++) {
            if (proc[i].arrival <= t && proc[i].remaining > 0 && !inQueue[i]) {
                q.push(i);
                inQueue[i] = true;
            }
        }

        if (q.empty()) {
            t++;
            continue;
        }

        int idx = q.front();
        q.pop();

        if (!proc[idx].started) {
            proc[idx].start = t;
            proc[idx].started = true;
        }

        int exec = min(quantum, proc[idx].remaining);
        proc[idx].remaining -= exec;
        t += exec;

        for (int i = 0; i < n; i++) {
            if (proc[i].arrival > t - exec && proc[i].arrival <= t && proc[i].remaining > 0 && !inQueue[i]) {
                q.push(i);
                inQueue[i] = true;
            }
        }

        if (proc[idx].remaining == 0) {
            proc[idx].finish = t;
            proc[idx].turnaround = proc[idx].finish - proc[idx].arrival;
            proc[idx].waiting = proc[idx].turnaround - proc[idx].burst;
            completed++;
        } else {
            q.push(idx);
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
    int n, quantum;
    cout << "Enter number of processes: ";
    cin >> n;
    cout << "Enter time quantum: ";
    cin >> quantum;
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
    roundRobin(proc, n, quantum);
    return 0;
}
