# MIPS CPU with Pipeline support

## Description

Todo

## Syntax guide for contributions

- Use spaces. 4 space tab.
- When doing if-else statements, you must use begin-end syntax, UNLESS all statements are single line. Keep begin-end consistent, basically.
  
**Good**:

```verilog
if (x) begin
    v = 10;
end
else
    v = 20;
    a = 4;
end
```

```verilog
if (p == 2)
    j = 12;
else
    j = 21;
```

**Bad**:

```verilog
if (x)
    v = 10;
else
    v = 20;
    a = 4;
end
```

- Inputs always come before Outputs.
- When naming variables which are present in multiple modules, name them like this: name_modulename. For example: i_fetch, a_decoder. It's confusing otherwise.
- Do not indent code inside the module block.

**Good**

```verilog
module a(...) begin

wire a;
assign a = 2;

end
```

**Bad**

```verilog
module a(...) begin

    wire a;
    assign a = 2;

end
```
