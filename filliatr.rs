use std::fs::canonicalize;
use std::process::Command;

fn integration_tests() {
    let test_dir = canonicalize("tests").unwrap();
    let test = canonicalize("tests").unwrap();
    let script_path = test_dir.join("test.sh");
    let compiler_path = canonicalize(env!("CARGO_BIN_EXE_petitc")).unwrap();
    let output = Command::new(script_path)
        .current_dir(test_dir)
        .arg(arg)
        .arg(compiler_path)
        .output()
        .unwrap()
        .stdout;
    let out_string = std::string::String::from_utf8(output).unwrap();
    print!("{}", out_string);
    assert!(!out_string.contains("ECHEC"));
}

#[test]
fn filliatr_syntax() {
    filliatr_with_arg("-1b");
}

#[test]
fn filliatr_typing() {
    filliatr_with_arg("-2b");
}

#[test]
fn filliatr_codegen() {
    filliatr_with_arg("-3b");
}
