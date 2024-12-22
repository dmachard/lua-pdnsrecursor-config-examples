pdnslog("pdns-recursor Lua script starting!", pdns.loglevels.Warning)

local ffi = require("ffi")

ffi.cdef[[
typedef struct pdns_ffi_param pdns_ffi_param_t;

typedef struct {
    uint16_t code;
    uint16_t size;
    void* data;
} pdns_ednsoption_t;

const char* pdns_ffi_param_get_qname(pdns_ffi_param_t* ref);
size_t pdns_ffi_param_get_edns_options_by_code(void* ref, uint16_t optionCode, const pdns_ednsoption_t** out);
void pdns_ffi_param_set_requestorid(void* ref, const char* id);
]]

local function getEDNS65001(ref)
  local options = ffi.new("const pdns_ednsoption_t*[1]")
  local optionCount = ffi.C.pdns_ffi_param_get_edns_options_by_code(ref, 65001, options)

  if optionCount > 0 then
    local option = options[0]
    pdnslog("EDNS 65001 option found", pdns.loglevels.Warning)
    return ffi.string(option.data, option.size)
  else
    return nil
  end
end

function gettag_ffi(obj)
  local qname = ffi.string(ffi.C.pdns_ffi_param_get_qname(obj))

  local uniqId = getUniqIdFromEDNS(obj)
  if uniqId then
    ffi.C.pdns_ffi_param_set_requestorid(obj, uniqId)
    pdnslog("Qname: " .. qname .. "UniqID: " .. uniqId, pdns.loglevels.Info)
  else
    pdnslog("UniqID not detected for " .. qname, pdns.loglevels.Warning)
  end

  return {}
end
