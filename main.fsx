type Token =
    | IncrementPointer
    | DecrementPointer
    | IncrementValue
    | DecrementValue
    | Input
    | Output
    | LoopStart
    | LoopEnd

type AstNode =
    | ChangePointerOp of int
    | ChangeValueOp of int
    | ValueInputOp
    | ValueOutputOp
    | Loop of AstNode list

type Lexer() =
    member _.Tokenize(input: string) : Token list =
        let rec tokenize (input: string) (tokens: Token list) =
            match input with
            | "" -> tokens |> List.rev
            | _ ->
                match input.[0] with
                | '>' -> tokenize input.[1..] (IncrementPointer :: tokens)
                | '<' -> tokenize input.[1..] (DecrementPointer :: tokens)
                | '+' -> tokenize input.[1..] (IncrementValue :: tokens)
                | '-' -> tokenize input.[1..] (DecrementValue :: tokens)
                | '.' -> tokenize input.[1..] (Output :: tokens)
                | ',' -> tokenize input.[1..] (Input :: tokens)
                | '[' -> tokenize input.[1..] (LoopStart :: tokens)
                | ']' -> tokenize input.[1..] (LoopEnd :: tokens)
                | _ -> tokenize input.[1..] tokens

        tokenize input []

type Parser() =
    let countConsecutiveTokens (tokens: Token list) (tokenType: Token) : int * Token list =
        let rec countTokens (tokens: Token list) (count: int) : int * Token list =
            match tokens with
            | t :: ts when t = tokenType -> countTokens ts (count + 1)
            | _ -> (count, tokens)

        countTokens tokens 1

    member _.Parse(tokens: Token list) : AstNode list =
        let rec parseTokens (tokens: Token list) (astNodes: AstNode list) : AstNode list * Token list =
            match tokens with
            | [] -> (List.rev astNodes, [])
            | IncrementPointer :: rest ->
                let (count: int, remainingTokens: Token list) =
                    countConsecutiveTokens rest IncrementPointer

                parseTokens remainingTokens (ChangePointerOp(count * 4) :: astNodes)
            | DecrementPointer :: rest ->
                let (count: int, remainingTokens: Token list) =
                    countConsecutiveTokens rest DecrementPointer

                parseTokens remainingTokens (ChangePointerOp -(count * 4) :: astNodes)
            | IncrementValue :: rest ->
                let (count: int, remainingTokens: Token list) =
                    countConsecutiveTokens rest IncrementValue

                parseTokens remainingTokens (ChangeValueOp count :: astNodes)
            | DecrementValue :: rest ->
                let (count: int, remainingTokens: Token list) =
                    countConsecutiveTokens rest DecrementValue

                parseTokens remainingTokens (ChangeValueOp -count :: astNodes)
            | Output :: rest -> parseTokens rest (ValueOutputOp :: astNodes)
            | Input :: rest -> parseTokens rest (ValueInputOp :: astNodes)
            | LoopStart :: rest ->
                let (loopNodes: AstNode list, remainingTokens: Token list) = parseTokens rest []
                parseTokens remainingTokens (Loop(loopNodes) :: astNodes)
            | LoopEnd :: rest -> (List.rev astNodes, rest)

        let (astNodes: AstNode list, _) = parseTokens tokens []
        astNodes


type Checker() =
    member _.Check(input: string) =
        let rec check (input: string) (depth: int) =
            match input with
            | "" -> depth = 0
            | _ ->
                match input.[0] with
                | '[' -> check input.[1..] (depth + 1)
                | ']' -> check input.[1..] (depth - 1)
                | _ -> check input.[1..] depth

        let valid: bool = check input 0
        valid

type CodeGenerator() =
    let tabulate (depth: int) =
        let rec tabulate (depth: int) (str: string) =
            match depth with
            | 0 -> str
            | _ -> tabulate (depth - 1) (str + "    ")

        let tabs: string = tabulate depth "    "
        tabs

    let generate_bf (code: string) =
        let mips_header: string = System.IO.File.ReadAllText "header.asm"
        let mips_code: string = mips_header + code
        let output_bf_file: string = "test.asm"
        System.IO.File.WriteAllText(output_bf_file, mips_code)

    member _.Generate(nodes: AstNode list) =
        let rec generate (nodes: AstNode list) (code: string) (loop_id: int) (depth: int) =
            match nodes with
            | [] -> code, loop_id
            | _ ->
                match nodes.[0] with
                | ChangePointerOp (amount) ->
                    let code: string = code + $"{tabulate depth}change_ptr({amount})\n"
                    generate nodes.[1..] code loop_id depth
                | ChangeValueOp (amount) ->
                    let code: string = code + $"{tabulate depth}change_value({amount})\n"
                    generate nodes.[1..] code loop_id depth
                | ValueInputOp ->
                    let code: string = code + $"{tabulate depth}read\n"
                    generate nodes.[1..] code loop_id depth
                | ValueOutputOp ->
                    let code: string = code + $"{tabulate depth}print\n"
                    generate nodes.[1..] code loop_id depth
                | Loop (loop_nodes: AstNode list) ->
                    let code: string =
                        code
                        + $"\
                        {tabulate depth}# Start Loop {loop_id}\n\
                        {tabulate depth}LOOP_{loop_id}:\n\
                        {tabulate depth}lw      BRK, 0(PTR)\n\
                        {tabulate depth}bnez    BRK, L_OPEN_{loop_id}\n\
                        {tabulate depth}j       L_CLOSE_{loop_id}\n\
                        {tabulate depth}L_OPEN_{loop_id}:\n\
                        "

                    let (loop_code: string), (new_loop_id: int) =
                        generate loop_nodes "" (loop_id + 1) (depth + 1)

                    let code: string =
                        code
                        + loop_code
                        + $"\
                        {tabulate depth}j   LOOP_{loop_id}\n\
                        {tabulate depth}L_CLOSE_{loop_id}:\n\
                        {tabulate depth}# End Loop {loop_id}\n\
                        "

                    generate nodes.[1..] code new_loop_id depth

        let (code: string), (_) = generate nodes "" 0 0
        generate_bf code
        printfn "SUCCESS"


let main (args: string array) =
    let path: string = args[1]
    let input: string = System.IO.File.ReadAllText path
    let checker: Checker = new Checker()

    let isBalanced: bool = checker.Check input

    if not isBalanced then
        printfn "SYNTAX ERROR"
    else

        let lexer: Lexer = new Lexer()
        let parser: Parser = new Parser()
        let codeGenerator: CodeGenerator = new CodeGenerator()

        let tokens: Token list = lexer.Tokenize input
        let nodes: AstNode list = parser.Parse tokens
        codeGenerator.Generate nodes

fsi.CommandLineArgs
|> Array.toList
|> List.toArray
|> main
