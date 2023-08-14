local M = {}

local function collect_job_results(cmd, cb)
    local results = {}

    local function on_output(_, line)
        table.insert(results, line)
    end

    local opts = {
        detach = false,
        stderr_buffered = true,
        stdout_buffered = true,
        on_stderr = on_output,
        on_stdout = on_output,
        on_exit = function(job_id, exit_code, event)
            cb(results, job_id, exit_code, event)
        end
    }

    return vim.fn.jobstart(cmd, opts)
end

local function run_in_qflist(cmd, efm, loclist)
    local setlist;
    local open;
    if loclist then
        open = vim.cmd.ll
        setlist = function(list, action, what)
            vim.fn.setloclist(0, list, action, what)
        end
    else
        open = vim.cmd.cc
        setlist = vim.fn.setqflist
    end

    print(cmd)
    collect_job_results(cmd, function(results, _)
        local lines = results[1]
        table.remove(lines) -- remove last empty line

        setlist({}, 'r', {
            lines = lines,
            efm = efm,
        })

        open()
    end)

end

function M.grep(args, opts)
    local cmd = vim.o.grepprg .. ' ' .. args
    return run_in_qflist(cmd, vim.o.grepformat, opts.loclist)
end

function M.make(args, opts)
    local cmd = vim.o.makeprg .. ' ' .. args
    return run_in_qflist(cmd, vim.o.errorformat, opts.loclist)
end

return M
