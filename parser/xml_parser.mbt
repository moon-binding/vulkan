// Simple XML parser for Vulkan registry
// Parses minimal subset needed for MVP validation

pub type XmlAttr {
  XmlAttr(String, String)
}

pub type XmlNode {
  XmlElement(String, Array[XmlAttr], Array[XmlNode])
  XmlText(String)
}

// Parse simple XML string into AST
// This is a very basic parser for the MVP - not production quality
pub fn parse_xml(content : String) -> Result[XmlNode, String] {
  let lines = String::split(content, "\n")
  parse_lines(lines, [], [])?
  |> Ok
}

fn parse_lines(
  lines : Array[String],
  current : Array[XmlNode],
  stack : Array[(String, Array[XmlAttr], Array[XmlNode])]
) -> Result[Array[XmlNode], String] {
  match Array::pop_front(lines) {
    None => Ok(current)
    Some(line) => {
      let trimmed = String::trim(line)
      if trimmed == "" || String::starts_with(trimmed, "<!--") {
        parse_lines(lines, current, stack)
      } else if String::starts_with(trimmed, "</") {
        // Closing tag
        match Array::pop(stack) {
          None => Err("Unmatched closing tag")
          Some((name, attrs, children)) => {
            let node = XmlElement(name, attrs, children)
            match Array::pop(stack) {
              None => parse_lines(lines, Array::append(current, [node]), stack)
              Some((pname, pattrs, pchildren)) =>
                parse_lines(lines, pchildren, Array::append(stack, [(pname, pattrs, Array::append(pchildren, [node]))]))
            }
          }
        }
      } else if String::starts_with(trimmed, "<") {
        // Opening tag
        let end_idx = String::index_of(trimmed, ">")?
        let tag_part = String::substring(trimmed, 1, end_idx)
        let rest = String::drop_prefix(trimmed, end_idx + 1)

        let self_closing = String::ends_with(tag_part, "/")
        let actual_tag = if self_closing {
          String::drop_suffix(tag_part, 1)
        } else {
          tag_part
        }

        let (name, attrs) = parse_tag_name_and_attrs(actual_tag)

        if self_closing {
          let node = XmlElement(name, attrs, [])
          parse_lines(lines, Array::append(current, [node]), stack)
        } else {
          parse_lines(lines, [], Array::append(stack, [(name, attrs, current)]))
        }
      } else {
        // Text content
        parse_lines(lines, Array::append(current, [XmlText(trimmed)]), stack)
      }
    }
  }
}

fn parse_tag_name_and_attrs(tag_part : String) -> (String, Array[XmlAttr]) {
  let parts = String::split(tag_part, " ")
  let name = match Array::get(parts, 0) { None => "" | Some(s) => s }

  let attrs : Array[XmlAttr] = []
  let mut result_attrs : Array[XmlAttr] = []

  let mut parts_iter = parts |> Array::drop(1)
  while parts_iter.length() > 0 {
    let part = parts_iter[0]
    parts_iter = parts_iter |> Array::drop(1)

    if part == "" {
      continue
    }

    let eq_idx = String::index_of(part, "=")
    match eq_idx {
      None => { }
      Some(idx) => {
        let key = String::substring(part, 0, idx)
        let value_part = String::drop_prefix(part, idx + 1)
        let value = if String::length(value_part) >= 2 {
          let inner = String::drop_prefix(value_part, 1)
          String::drop_suffix(inner, 1)
        } else {
          value_part
        }
        result_attrs = result_attrs |> Array::append([XmlAttr(key, value)])
      }
    }
  }

  (name, result_attrs)
}

// Helper to find attribute value
pub fn get_attr(node : XmlNode, name : String) -> Option[String] {
  match node {
    XmlElement(_, attrs, _) => {
      let mut result : Option[String] = None
      for attr in attrs {
        match attr {
          XmlAttr(key, value) => {
            if key == name {
              result = Some(value)
            }
          }
        }
      }
      result
    }
    _ => None
  }
}

// Helper to find first child with tag name
pub fn find_child(node : XmlNode, name : String) -> Option[XmlNode] {
  match node {
    XmlElement(_, _, children) => {
      for child in children {
        match child {
          XmlElement(child_name, _, _) => {
            if child_name == name {
              return Some(child)
            }
          }
          _ => { }
        }
      }
      None
    }
    _ => None
  }
}

// Helper to find all children with tag name
pub fn find_children(node : XmlNode, name : String) -> Array[XmlNode] {
  match node {
    XmlElement(_, _, children) => {
      let mut result : Array[XmlNode] = []
      for child in children {
        match child {
          XmlElement(child_name, _, _) => {
            if child_name == name {
              result = result |> Array::append([child])
            }
          }
          _ => { }
        }
      }
      result
    }
    _ => []
  }
}

// Helper to get text content
pub fn get_text(node : XmlNode) -> String {
  match node {
    XmlElement(_, _, children) => {
      let mut result = ""
      for child in children {
        match child {
          XmlText(text) => {
            result = result + text
          }
          _ => { }
        }
      }
      result
    }
    XmlText(text) => text
  }
}
