let rec change_value (change: int) (str: string) (len: int) (out: string) =
    match str with
    | "" -> str, $"{out}    change_value({change})\n"
    | _ ->
        match str[0] with
        | '+' -> change_value (change + 1) str[1..len] len out
        | '-' -> change_value (change - 1) str[1..len] len out
        | _ -> str, $"{out}    change_value({change})\n"

let rec change_ptr (change: int) (str: string) (len: int) (out: string) =
    match str with
    | "" -> str, $"{out}    change_ptr({change * 4})\n"
    | _ ->
        match str[0] with
        | '>' -> change_ptr (change + 1) str[1..len] len out
        | '<' -> change_ptr (change - 1) str[1..len] len out
        | _ -> str, $"{out}    change_ptr({change * 4})\n"

let print (out: string) : string = $"{out}    print\n"

let read (out: string) : string = $"{out}    read\n"

let exit (out: string) : string = $"{out}    exit\n"

let get_stack (op: char) (stack: list<int>) (loop_count: int) =
    match op with
    | '[' -> loop_count :: stack, (loop_count :: stack).Head
    | _ ->
        let temp = stack.Head
        stack.Tail, temp

let start_loop (str: string) (len: int) (out: string) (stack: list<int>) (loop_count: int) =
    let (new_stack: list<int>, loop_num: int) = get_stack '[' stack loop_count

    new_stack,
    str[1..len],
    $"{out}    \
    lw  $t1, 0($s0)\n    \
    beq $t1, $0, L_CLOSE_{loop_num}\n\n\
    L_OPEN_{loop_num}:\n"

let end_loop (str: string) (len: int) (out: string) (stack: list<int>) (error: int) =
    if (stack = []) then
        stack, str[1..len], out, 1
    else
        let (new_stack: list<int>, loop_num: int) = get_stack ']' stack 0

        new_stack,
        str[1..len],
        $"{out}    \
        lw  $t1, 0($s0)\n\n\
        L_CLOSE_{loop_num}:\n    \
        bne $t1, $0, L_OPEN_{loop_num}\n",
        0

let generate_bf (str: string) =
    let output_bf_file: string = "test.asm"
    System.IO.File.WriteAllText(output_bf_file, str)

let main (args: string array) =
    let path: string = args[1]

    // read the file contents at path
    let bf_in: string = System.IO.File.ReadAllText path
    // get the string length of bf_in
    let len: int = String.length bf_in

    // loop through the string bf_in
    let rec parse_bf (error: int) (loop_count: int) (stack: int list) (str: string) (out: string) =
        if (error = 1) then
            printfn "SYNTAX ERROR"
            0 |> ignore
        else if (str = "") then
            if stack <> [] then
                printfn "SYNTAX ERROR"
            else
                printfn "SUCCESS"
                generate_bf out

            0 |> ignore
        else
            match str[0] with
            | '+' ->
                change_value 0 str len out
                ||> parse_bf error loop_count stack
            | '-' ->
                change_value 0 str len out
                ||> parse_bf error loop_count stack
            | '>' ->
                change_ptr 0 str len out
                ||> parse_bf error loop_count stack
            | '<' ->
                change_ptr 0 str len out
                ||> parse_bf error loop_count stack
            | '.' ->
                print out
                |> parse_bf error loop_count stack str[1..len]
            | ',' ->
                read out
                |> parse_bf error loop_count stack str[1..len]
            | '?' ->
                exit out
                |> parse_bf error loop_count stack str[1..len]
            | '[' ->
                start_loop str len out stack loop_count
                |||> parse_bf error (loop_count + 1)
            | ']' ->
                end_loop str len out stack error
                |> fun (a, b, c, e) -> parse_bf e loop_count a b c
            | _ -> parse_bf error loop_count stack str[1..len] out

    let mips_header: string = System.IO.File.ReadAllText "header.asm"

    let stack: int list = []
    let loop_count: int = 0
    let error: int = 0

    parse_bf error loop_count stack bf_in mips_header



fsi.CommandLineArgs
|> Array.toList
|> List.toArray
|> main
