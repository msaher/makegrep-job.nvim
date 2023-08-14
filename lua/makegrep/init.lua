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
return M
