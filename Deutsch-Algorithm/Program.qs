namespace QuantumDeutschAlgorithm {

    open Microsoft.Quantum.Canon;
    open Microsoft.Quantum.Intrinsic;
    open Microsoft.Quantum.Measurement;

    operation SetQubitState(desired : Result, target : Qubit) : Unit {
        if desired != M(target) {
            X(target);
        }
    }
    
    operation Deutsch(Oracle : (Qubit, Qubit) => Unit) : Result {
        // Allocate qubits
        use (x, y) = (Qubit(), Qubit());

        SetQubitState(Zero, x);
        SetQubitState(One, y);

        // Apply Hadamard transformation
        H(x);
        H(y);

        // Apply oracle
        Oracle(x, y);

        H(x);

        let result = M(x);

        // Clean qubits
        SetQubitState(Zero, x);
        SetQubitState(Zero, y);

        return result;
    }

    operation Uf0(x : Qubit, y : Qubit) : Unit {
        // f(x) = 0
    }

    operation Uf1(x : Qubit, y : Qubit) : Unit {
        // f(x) = 1
        X(y);
    }

    operation Uf2(x : Qubit, y : Qubit) : Unit {
        // f(x) = x
        CNOT(x, y);
    }

    operation Uf3(x : Qubit, y : Qubit) : Unit {
        // f(x) = !x
        X(x);
        CNOT(x, y);
        X(x);
    }

    @EntryPoint()
    operation Main() : Unit {

        // Returns 0 - if boolean function is constant
        //         1 - if boolean function is balanced 
        Message($"f(x) = 0   | {Deutsch(Uf0)}");
        Message($"f(x) = 1   | {Deutsch(Uf1)}");
        Message($"f(x) = x   | {Deutsch(Uf2)}");
        Message($"f(x) = !x  | {Deutsch(Uf3)}");
    }
}
